require 'flat_hash/vcs'
require 'flat_hash/changeset'

class FlatHash::Hg < FlatHash::Vcs
  def name
    :hg
  end

  def addremovecommit comment
    sh "hg addremove"
    commit comment
  end

  def changesets *path
    sh("hg log --removed --template \"{node}\\n\" #{File.join(*path)}")
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
    sh("hg cat -r #{commit} #{path}").join("\n")
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