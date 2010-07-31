require 'fileutils'

module FlatHash; end

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

  def << entry
    write entry.name, entry.content
  end

  def read key
    open_serialiser(key) { |serialiser| serialiser.read }
  end

  alias :[] :read

  def write key, hash
    FileUtils.mkdir_p @path
    open_serialiser(key,'w') { |serialiser| serialiser.write hash }
  end

  alias :[]= :write
private
  def open_serialiser key, mode='r'
    File.open(File.join(@path,key),mode) { |file| yield FlatHash::Serialiser.new file }
  end
end