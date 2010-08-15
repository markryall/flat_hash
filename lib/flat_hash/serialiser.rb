module FlatHash; end

class FlatHash::Serialiser
  def initialize io
    @io = io
  end

  def read
    hash = {}
    first = true
    key, value = nil, ''
    @io.each do |line|
      line.chomp!
      return read_as_yaml(line) if first and line =~ /^--- /
      first = false
      if key
        if line == '<----->'
          hash[key] = value
          key, value = nil, ''          
        else
          value << "\n" if value.length > 0
          value << line
        end
      else
        key = line
      end
    end
    hash[key] = value if key
    hash
  end

  def write hash
    first = true
    hash.keys.sort.each do |key|
      @io.puts '<----->' unless first
      @io.puts key
      @io.puts hash[key]
      first = false
    end
  end
private
  def read_as_yaml line
    sio = StringIO.new(line)
    @io.each { |line| sio.puts line.chomp }
    hash = YAML::load(sio.string)
    hash['table'].instance_of?(Hash) ? convert_keys(hash['table']) : hash
  end

  def convert_keys hash
    converted = {}
    hash.keys.each {|k| converted[k.to_s] = hash[k]}
    converted
  end
end