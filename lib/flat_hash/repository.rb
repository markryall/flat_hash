require 'forwardable'
require 'flat_hash/directory'
require 'flat_hash/git'
require 'flat_hash/hg'

module FlatHash
  class Repository < Directory
    extend Forwardable
    def_delegators :@vcs, :changesets

    def initialize name
      super
      system 'ls'
      @vcs = Git.new if File.exist?('.git')
      @vcs = Hg.new if File.exist?('.hg')
      raise "could not determine repository type" unless @vcs
    end
  end
end