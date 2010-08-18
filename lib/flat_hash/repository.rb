require 'forwardable'
require 'flat_hash/directory'
require 'flat_hash/git'
require 'flat_hash/hg'

class FlatHash::Repository < FlatHash::Directory
  extend Forwardable
  def_delegators :@vcs, :changesets

  def initialize serialiser, path
    super
    @vcs = FlatHash::Git.new if File.exist?('.git')
    @vcs = FlatHash::Hg.new if File.exist?('.hg')
  end

  def vcs_supported?
    !@vcs.nil?
  end

  def history key=nil
    return [] unless vcs_supported?
    path = key ? File.join(@path, key) : @path
    @vcs.changesets(path).map {|cs| @vcs.changeset cs }
  end

  def element_at changeset, key
    return {} unless vcs_supported?
    content = @vcs.content_at(File.join(@path, key),changeset)
    @serialiser.read StringIO.new(content)
  end
end