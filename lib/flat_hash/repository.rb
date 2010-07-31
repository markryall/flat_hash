module FlatHash
  class Vcs
    attr_reader :type
    
    def sh command
      lines = []
      IO.popen("#{command} 2>&1") {|io| io.each {|l| lines << l.chomp } }
      raise "\"#{command}\" failed with status #{$?}:\n#{lines.join("\n")}" unless $?.success?
      lines
    end
  end

  class Git < Vcs
    def initialize
      @type = :git
    end
    
    def history path
      sh("git log --format=%H -- #{path}")
    end

    def entry_at path, commit
      files = sh("git show --pretty=\"format:\" --name-only #{commit}")
      puts files.inspect 
      return "<deleted>" unless files.include?(path)
      sh("git show #{commit}:#{path}").join("\n")
    end
    
    def files_changed commit
      sh("git show --pretty=\"format:\" --name-only #{commit}")
    end
  end

  class Hg < Vcs
    def initialize
      @type = :hg
    end
    
    def history path
      sh("hg log --removed --template \"{node}\\n\" #{path}")
    end

    def entry_at path, commit
      sh("hg cat -r #{commit} #{path}").join("\n")
    end

    def files_changed commit
      style = File.join(File.dirname(__FILE__), 'delta.hg')
      sh("hg log --style \"#{style}\" -r #{commit} --removed")
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

    def files_changed commit
      @vcs.files_changed commit
    end

    def entry_at path, commit
      @vcs.entry_at File.join(@path, path), commit
    end

    def history *paths
      return [] unless File.exist?(@path)
      @vcs.history File.join(@path, *paths)
    end
  
    def type
      return @vcs.type
    end
  end
end