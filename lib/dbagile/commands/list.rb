module DbAgile
  module Commands
    #
    # List available database handler listed in ~/.dbagile file
    #
    class List < ::DbAgile::Commands::Command
      
      # Verbose ?
      attr_accessor :verbose
      
      # Creates a command instance
      def initialize
        super
        @verbose = false
      end
      
      # Returns the command banner
      def banner
        "usage: dba list"
      end

      # Short help
      def short_help
        "List available database configurations (found in ~/.dbagile)"
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
        opt.separator nil
        opt.separator "Options:"
        opt.on("--verbose", "-v", "Displays full contents of ~/.dbagile file") do |value|
          self.verbose = true
        end
      end
      
      # Executes the command
      def execute_command
        config_file = DbAgile::load_user_config_file
        if verbose
          info config_file.inspect
        else
          unless config_file.empty?
            info("Available databases are:")
            config_file.each do |config|
              msg = config_file.current?(config) ? "  -> " : " "*5
              msg += align(config.name,15)
              msg += " "
              msg += config.uri
              info(msg)
            end
          else
            info("No database configuration found. Checks ~/.dbagile")
          end
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile