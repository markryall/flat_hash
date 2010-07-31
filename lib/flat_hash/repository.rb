module FlatHash
  class FlatHash::Vcs
    attr_reader :type
    
    def sh command
      lines = []
      IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
      raise "process failed with status #{$?}" unless $?.success?
      lines
    end
  end

  class FlatHash::Git < FlatHash::Vcs
    def initialize
      @type = :git
    end
    
    def history path
      sh("git log --format=%H #{path}")
    end
  end

  class FlatHash::Hg < FlatHash::Vcs
    def initialize
      @type = :hg
    end
    
    def history path
      sh("hg log --template \"{node}\\n\" #{path}")
    end
  end

  class FlatHash::Repository < FlatHash::Directory
    def initialize name
      super
      @vcs = FlatHash::Git.new if File.exist?('.git')
      @vcs = FlatHash::Hg.new if File.exist?('.hg')
      raise "could not determine repository type" unless @vcs
    end

    def history
      return [] unless File.exist?(@path)
      @vcs.history @path
    end
  
    def type
      return @vcs.type
    end
  end
end