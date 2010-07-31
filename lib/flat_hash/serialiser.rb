module FlatHash; end

class FlatHash::Serialiser
  def initialize io
    @io = io
  end

  def read
    hash = {}
    key, value = nil, ''
    @io.each do |line|
      line.chomp!
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
end