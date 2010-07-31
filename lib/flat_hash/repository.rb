module FlatHash
  class Vcs
    attr_reader :type
    
    def sh command
      lines = []
      IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
      raise "process failed with status #{$?}" unless $?.success?
      lines
    end
  end

  class Git < Vcs
    def initialize
      @type = :git
    end
    
    def history path
      sh("git log --format=%H #{path}")
    end
  end

  class Hg < Vcs
    def initialize
      @type = :hg
    end
    
    def history path
      sh("hg log --template \"{node}\\n\" #{path}")
    end
  end

  class Repository < Directory
    def initialize name
      super
      system 'ls'
      @vcs = Git.new if File.exist?('.git')
      @vcs = Hg.new if File.exist?('.hg')
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