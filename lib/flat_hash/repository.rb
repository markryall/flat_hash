require 'flat_hash/git'
require 'flat_hash/hg'

module FlatHash
  class Repository < Directory
    def initialize name
      super
      system 'ls'
      @vcs = Git.new if File.exist?('.git')
      @vcs = Hg.new if File.exist?('.hg')
      raise "could not determine repository type" unless @vcs
    end

    def files_changed commit
      @vcs.files_changed commit
    end

    def entry_at path, commit
      @vcs.entry_at File.join(@path, path), commit
    end

    def history *paths
      return [] unless File.exist?(@path)
      @vcs.history File.join(@path, *paths)
    end
  
    def type
      return @vcs.type
    end
  end
end