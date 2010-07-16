module DbAgile
  class Environment
    # 
    # Environment's robustness contract.
    #
    module Robustness
      
      #
      # Handles an error that occured during command execution.
      #
      # @param [Exception] error the error that was raised
      # @return nil to continue execution, an error to raise otherwise
      #
      def on_error(command, error)
        case error
          when OptionParser::ParseError
            say(error.message, :red)
            display(command.options.to_s)
          when DbAgile::Error, Sequel::Error
            say(error.message, :red)
          else
            say("ERROR: #{error.message}", :red)
            display(error.backtrace.join("\n"))
        end
        error
      end

    end # module Robustness
  end # class Environment
end # module DbAgile