module DbAgile
  class Engine
    class ConsoleEnvironment
      
      # Highline instance
      attr_reader :highline
      
      # Creates a highline environment
      def initialize
        require 'readline'
        load_history
        begin 
          require 'highline'
          @highline = HighLine.new
        rescue LoadError
          puts "DbAgile console is much more friendly with highline\ntry 'gem install highline'"
        end
      end
      
      # Loads dbagile engine's history
      def load_history
        histfile = File.join(ENV['HOME'], '.dbagile_history')
        if File.exists?(histfile)
          File.readlines(histfile).each{|c| 
            Readline::HISTORY.push(c) unless c.strip.empty?
          }
        end
      end
      
      # Saves dbagile engine's history
      def save_history
        histfile = File.join(ENV['HOME'], '.dbagile_history')
        File.open(histfile, 'w') do |io|
          hist = Readline::HISTORY.to_a
          hist = hist.reverse[0..(ENV['HISTORY'].to_i || 100)]
          hist.reverse.each{|c| 
            (io << c << "\n") unless c.strip.empty?
          }
        end
      end
      
      # Stolen on http://bogojoker.com/readline/
      def readline_with_hist_management(what)
        line = Readline.readline(what, true)
        return nil if line.nil?
        if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
          Readline::HISTORY.pop
        end
        line
      end

      # Asks something
      def ask(what)
        line = readline_with_hist_management(what)
        if line =~ /^([^\s]+)\s*(.*)$/
          cmd, args = $1, Kernel.eval("[#{$2}]")
          [cmd, args]
        else
          error("Unknown command: #{line}")
          [nil, nil]
        end
      end
      alias :next_command :ask
      
      # Says something
      def say(what)
        highline ? highline.say(what.to_s) : puts(what.to_s)
      end
      
      # Prints an error
      def error(message)
        message = "ERROR: #{message}"
        highline ? highline.say(highline.color(message, :red)) : puts(message)
      end
      
    end # class HighlineEnvironment
  end # class Engine
end # module DbAgile