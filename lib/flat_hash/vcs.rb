class FlatHash::Vcs
  def sh command
    lines = []
    IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
    raise "\"#{command}\" failed with status #{$?}:\n#{lines.join("\n")}" unless $?.success?
    lines
  end
end