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

  def []= key, hash
    write key, hash
  end

  def [] key
    read key
  end

  def read key
    File.open(path(key)) do |file|
      FlatHash::Serialiser.new(file).read
    end
  end

  def write key, hash
    FileUtils.mkdir_p @path
    File.open(path(key),'w') do |file|
      FlatHash::Serialiser.new(file).write(hash)
    end
  end
private
  def path key
    File.join(@path,key)
  end
end