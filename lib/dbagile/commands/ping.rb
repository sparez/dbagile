module DbAgile
  module Commands
    #
    # Pings a configuration
    #
    class Ping < ::DbAgile::Commands::Command
      
      # Name of the configuration to ping
      attr_accessor :match
      
      # Creates a command instance
      def initialize
        super
      end
      
      # Returns the command banner
      def banner
        "usage: dba ping [NAME]"
      end

      # Short help
      def short_help
        "Ping a configuration (current one by default)"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Contribute to options
      def add_options(opt)
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size <= 1
        if arguments.empty?
          self.match = nil
        else
          self.match = arguments.shift.to_sym
        end
      end
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file, self.match)
        
        # Make the job now
        config.connect.ping
        info "Ping ok (#{config.uri})"
      end
      
    end # class List
  end # module Commands
end # module DbAgile