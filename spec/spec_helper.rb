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

def in_vcs_repository vcs
  in_temp_directory do
    vcs.init
    yield vcs
  end
end

def with_directory
  yield FlatHash::Directory.new('.cards')
end

def with_repository
  yield FlatHash::Repository.new('.cards')
end

class Vcs
  def init
    execute "init"
  end

  def commit comment
    execute "commit -m \"#{comment}\""
  end
  
  def execute command
    sh "#{name} #{command}"
  end
end

class Git < Vcs
  def name
    :git
  end

  def addremovecommit comment
    sh "git add -A"
    sh "git ls-files --deleted -z | xargs -0 git rm"
    commit comment
  end
end

class Hg < Vcs
  def name
    :hg
  end

  def addremovecommit comment
    sh "hg addremove"
    commit comment
  end
end