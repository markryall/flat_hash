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

  def initialize path
    @path = path
  end

  def each
    return unless File.exist?(@path)
    Dir.foreach(@path) do |path|
      basename = File.basename(path)
      yield basename unless ['.','..'].include?(basename)
    end
  end

  def destroy key
    FileUtils.rm(File.join(@path,key))
  end

  def << entry
    write entry.name, entry.content
  end

  def read key
    open_serialiser(key) { |serialiser| add_key(serialiser.read, key) }
  end

  alias :[] :read

  def write key, hash
    FileUtils.mkdir_p @path
    open_serialiser(key,'w') { |serialiser| serialiser.write hash }
  end

  alias :[]= :write
private
  def open_serialiser key, mode='r'
    File.open(File.join(@path,key),mode) { |file| yield FlatHash::Serialiser.new(file) }
  end

  def add_key hash, key
    hash.meta_eval {
      define_method(:id) { key }
    }
    hash
  end
end