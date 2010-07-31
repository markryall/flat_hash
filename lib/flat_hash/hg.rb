require 'flat_hash/vcs'

class FlatHash::Hg < FlatHash::Vcs
  def history path
    sh("hg log --removed --template \"{node}\\n\" #{path}")
  end

  def entry_at path, commit
    sh("hg cat -r #{commit} #{path}").join("\n")
  end

  def files_changed commit
    style = File.join(File.dirname(__FILE__), 'delta.hg')
    sh("hg log --style \"#{style}\" -r #{commit} --removed")
  end
end