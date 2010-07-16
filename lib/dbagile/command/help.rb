module DbAgile
  class Command
    #
    # Show help of a given command
    #
    class Help < Command
      
      # Name of the configuration to add
      attr_accessor :command
      
      # Returns the command banner
      def banner
        "usage: dba help COMMAND"
      end

      # Short help
      def short_help
        "Show help for a specific command"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.command = valid_argument_list!(arguments, Symbol)
        self.command = has_command!(self.command)
      end
      
      # Executes the command
      def execute_command
        display(command.short_help)
        display(command.options)
      end
      
    end # class List
  end # class Command
end # module DbAgile