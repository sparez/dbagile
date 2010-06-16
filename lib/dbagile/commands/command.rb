require 'optparse'
require 'fileutils'
module DbAgile
  module Commands
    class Command
      
      # Creates an empty command instance
      def initialize
        @buffer = STDOUT
      end
      
      # Parses commandline options provided as an array of Strings.
      def options
        @options  ||= OptionParser.new do |opt|
          opt.program_name = File.basename $0
          opt.version = DbAgile::VERSION
          opt.release = nil
          opt.summary_indent = ' ' * 4
          opt.banner = self.banner.gsub(/^[ \t]+/, "")
    
          opt.separator nil
          opt.separator "Options:"
    
          add_options(opt)

          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opt.on_tail("-h", "--help", "Show this message") do
            exit(nil, true)
          end

          # Another typical switch to print the version.
          opt.on_tail("--version", "Show version") do
            exit(opt.program_name << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau", false)
          end
    
          opt.separator nil
        end
      end

      # Runs the command
      def run(requester_file, argv)
        @requester_file = requester_file
        prepare_command(argv)
        check_command
        execute_command
      rescue OptionParser::InvalidOption => ex
        exit(ex.message)
      rescue SystemExit
      rescue Exception => ex
        error <<-EOF
          A severe error occured. Please report this to the developers.
        
          #{ex.class}: #{ex.message}
        EOF
        error ex.backtrace.join("\n")
      end
      
      # Exits with a message, showing options if required
      def exit(msg = nil, show_options=true)
        info msg if msg
        puts options if show_options
        Kernel.exit(-1)
      end
      
      def info(msg)
        raise ArgumentError unless msg.kind_of?(String)
        @buffer << msg.gsub(/^[ \t]+/, '') << "\n"
      end
      alias :error :info
      
      # Contribute to options
      def add_options(opt)
      end
      
      # Prepares the command
      def prepare_command(argv)
        rest = options.parse!(argv)
        normalize_pending_arguments(rest)
        self
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit
      end
      
      # Checks the command and exit if any option problem is found
      def check_command
      end
      
      # Executes the command
      def execute_command
      end
      
      # Returns the command banner
      def banner
        raise "Command.banner should be overriden by subclasses"
      end
      
      # Runs the sub-class defined command
      def __run(requester_file, arguments)
        raise "Command._run should be overriden"
      end

    end # class Command
  end # module Commands
end # module DbAgile
