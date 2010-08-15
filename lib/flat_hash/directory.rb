require 'fileutils'

module FlatHash; end

class Object
  def metaclass
    (class << self; self; end)
  end
  
  def meta_eval &block
    metaclass.instance_eval &block
  end
end

class FlatHash::Directory
  include Enumerable

  def initialize serialiser, path
    @serialiser, @path = serialiser, path
  end

  def each
    return unless File.exist?(@path)
    Dir.foreach(@path) do |path|
      basename = File.basename(path)
      yield self[basename] unless ['.','..'].include?(basename)
    end
  end

  def destroy key
    FileUtils.rm(File.join(@path,key))
  end

  def << entry
    write entry.name, entry.content
  end

  def read key
    File.open(File.join(@path,key)) {|io| add_key(@serialiser.read(io), key) }
  end

  alias :[] :read

  def write key, hash
    FileUtils.mkdir_p @path
    File.open(File.join(@path,key),'w') {|io| @serialiser.write io, hash }
  end

  alias :[]= :write
private
  def add_key hash, key
    hash.meta_eval {
      define_method(:id) { key }
    }
    hash
  end
end