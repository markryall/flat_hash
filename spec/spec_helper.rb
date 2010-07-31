$: << File.dirname(__FILE__)+'/../lib'
require 'flat_hash'
require 'tempfile'
require 'fileutils'

def in_temp_directory
  tempfile = Tempfile.new('')
  tempdir = tempfile.path
  tempfile.close!
  begin
    FileUtils.mkdir_p tempdir
    Dir.chdir(tempdir) do
      yield
    end
  ensure
    FileUtils.rm_rf tempdir
  end
end

def sh command, options={}
  IO.popen("#{command} 2>&1") {|io| io.each {|l| puts l if options[:verbose] } }
  raise "process failed with status #{$?}" unless $?.success?
end