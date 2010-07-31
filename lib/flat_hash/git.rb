require 'flat_hash/vcs'

class FlatHash::Git < FlatHash::Vcs
  def history path
    sh("git log --format=%H -- #{path}")
  end

  def entry_at path, commit
    files = sh("git show --pretty=\"format:\" --name-only #{commit}")
    puts files.inspect 
    return "<deleted>" unless files.include?(path)
    sh("git show #{commit}:#{path}").join("\n")
  end
  
  def files_changed commit
    sh("git show --pretty=\"format:\" --name-only #{commit}")
  end
end