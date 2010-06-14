module TestUtil
  # MT-unsafe
  def self.require(dir, *features)
    begin
      # avoid 'already initialized constant FizzBuzz' warning
      silent do
        $:.unshift(dir)
        features.each do |feature|
          Kernel.require feature
        end
        $:.shift
      end

#        Dir.chdir(dir) do
#          # $:.unshift('.') if RUBY_VERSION.to_f >= 1.9
#          features.each do |feature|
#            Kernel.require feature
#          end
#        end
#      end

    ensure
      features.each do |feature|
        $".delete(feature)
      end
    end
  end

  # MT-unsafe
  def self.silent
    if $DEBUG
      yield
    else
      back = $VERBOSE
      $VERBOSE = nil
      begin
        yield
      ensure
        $VERBOSE = back
      end
    end
  end

  def self.filecompare(expectedfile, actualfile)
    expected = loadfile(expectedfile)
    actual = loadfile(actualfile)
    if expected != actual
      raise "#{File.basename(actualfile)} is different from #{File.basename(expectedfile)}"
    end
  end

  def self.loadfile(file)
    File.open(file) { |f| f.read }
  end

  def self.start_server_thread(server)
    t = Thread.new {
      Thread.current.abort_on_exception = true
      server.start
    }
    t
  end
end
