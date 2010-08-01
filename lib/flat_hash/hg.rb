require 'flat_hash/vcs'

Changeset = Struct.new :id, :revision, :time, :author, :modifications, :additions, :deletions, :description

class FlatHash::Hg < FlatHash::Vcs
  def history path=''
    sh("hg log --removed --template \"{node}\\n\" #{path}")
  end
  alias :changesets :history

  def changeset id
    change = Changeset.new
    lines = files_changed(id)
    idrevline = lines.shift
    if idrevline =~ /(.+):(.+)/
      change.revision = $1.to_i
      change.id = $2
    end
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

  def entry_at path, commit
    sh("hg cat -r #{commit} #{path}").join("\n")
  end

  def files_changed commit
    style = File.join(File.dirname(__FILE__), 'delta.hg')
    sh("hg log --style \"#{style}\" -r #{commit} --removed")
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