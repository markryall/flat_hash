class FlatHash::Vcs
  def init
    execute "init"
  end

  def commit comment
    execute "commit -m \"#{comment}\""
  end
  
  def execute command
    sh "#{name} #{command}"
  end

  def sh command
    lines = []
    IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
    unless $?.success?
      raise "\"#{command}\" failed with status #{$?}:\n#{lines.join("\n")}" unless block_given?
      return yield($?, lines)
    end
    lines
  end
end