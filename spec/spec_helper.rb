$: << File.dirname(__FILE__)+'/../lib'
$: << File.dirname(__FILE__)

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
  lines=[]
  IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
  raise "\"#{command}\" failed with status #{$?}: #{lines.join("\n")}" unless $?.success?
end

def in_vcs_working_directory
  vcs = vcs_class.new
  in_temp_directory do
    vcs.init
    yield vcs
  end
end

def with_directory
  yield FlatHash::Directory.new(FlatHash::Serialiser.new, '.cards')
end

def with_repository
  yield FlatHash::Repository.new(FlatHash::Serialiser.new, '.cards')
end

def write content, *paths
  path = File.join(*paths)
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') {|file| file.puts content}
end

def delete *paths
  FileUtils.rm(File.join(*paths))
end