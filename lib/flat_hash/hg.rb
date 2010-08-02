require 'flat_hash/vcs'
require 'flat_hash/changeset'

class FlatHash::Hg < FlatHash::Vcs
  def name
    :hg
  end

  def addremovecommit comment
    execute "addremove"
    commit comment
  end

  def changesets path='.'
    execute "log --removed --template \"{node}\\n\" #{path}"
  end

  def changeset id
    change = FlatHash::Changeset.new
    style = File.join(File.dirname(__FILE__), 'delta.hg')
    lines = sh("hg log --style \"#{style}\" -r #{id} --removed")
    change.id = lines.shift
    change.time = lines.shift
    change.author = lines.shift
    change.modifications = read_until(lines, 'additions:')
    change.additions = read_until(lines, 'deletions:')
    change.deletions = read_until(lines, 'description:')
    change.modifications = change.modifications - change.additions
    change.modifications = change.modifications - change.deletions
    change.description = lines.join("\n")
    change
  end

  def content_at path, commit
    execute("cat -r #{commit} #{path}").join("\n")
  end

  def files_at commit, path='.'
    sh "hg locate -r #{commit} '#{path}/*'" do |status, lines|
      raise "failed with status #{status.exitstatus}:\n#{lines.join("\n")}" unless status.exitstatus == 1
      []
    end
  end
private
  def read_until lines, end_line
    entries = []
    loop do
      line = lines.shift
      break if line == end_line
      entries << line
    end
    entries
  end
end