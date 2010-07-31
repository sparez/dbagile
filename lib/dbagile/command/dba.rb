module DbAgile
  class Command
    #
    # Agile SQL databases and tools for database administrators
    #
    # Usage: dba [--help] [--version] 
    #        dba help <subcommand>
    #        dba [--repository=DIR] [--use=DB] [--no-interactive] <subcommand> [OPTIONS] [ARGS]
    #
    # DbAgile aims at supporting database administrators and developers of database
    # oriented application. Read more about it on http://blambeau.github.com/dbagile.
    #
    class Dba < Command
      Command::build_me(self, __FILE__)
      
      # Continue after my options
      attr_accessor :stop_after_options

      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--repository=DIR", 
               "Use a specific repository (current is #{environment.friendly_repository_path})") do |value|
          environment.repository_path = value
        end
        opt.on("--use=DB", 
               "Use a specific database") do |value|
          environment.repository.current_db_name = value.to_sym
        end
        opt.on("--[no-]interactive", "[Dis-]allow interactive mode") do |value|
          environment.interactive = value
        end
        opt.on("--[no-]backtrace", "Print a backtrace when an error occurs") do |value|
          environment.show_backtrace = value
        end
        opt.on_tail("--help", "Show list of available subcommands") do
          show_long_help
          self.stop_after_options = true
        end
        opt.on_tail("--version", "Show version") do
          flush("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau")
          self.stop_after_options = true
        end
      end

      # Returns commands by category
      def commands_by_categ
        return @commands_by_categ if @commands_by_categ
        @commands_by_categ = Hash.new{|h,k| h[k] = []}
        Command.subclasses.each do |subclass|
          next if subclass == Dba
          name     = Command::command_name_of(subclass)
          command  = Command::command_for(name, environment)
          category = command.category
          raise "Unknown command category #{category}" unless DbAgile::Command::CATEGORIES.include?(category)
          @commands_by_categ[category] << command
        end
        @commands_by_categ
      end

      # Show command help for a specific category
      def show_commands_help(category)
        commands_by_categ[category].each do |command|
          flush(options.summary_indent + command.command_name.ljust(30) + command.summary.to_s)
        end
      end

      # Shows the short help
      def show_short_help
        flush banner
        flush options.summarize
        flush "\n"
      end
      alias :show_help :show_short_help
      
      # Shows the long help
      def show_long_help
        show_short_help
        DbAgile::Command::CATEGORIES.each{|categ|
          flush DbAgile::Command::CATEGORY_NAMES[categ]
          show_commands_help(categ)
          flush "\n"
        }
      end
      
      # Runs the command
      def unsecure_run(requester_file, argv)
        # My own options
        my_args = []
        while argv.first =~ /^--/
          my_args << argv.shift
        end
        options.parse!(my_args)
        
        # Invoke sub command
        unless stop_after_options
          invoke_subcommand(requester_file, argv) 
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      end
      
      # Invokes the subcommand
      def invoke_subcommand(requester_file, argv)
        # Command execution
        if argv.size >= 1
          ensure_repository{
            command = has_command!(argv.shift, environment)
            command.run(requester_file, argv)
          }
        else
          show_long_help
        end
      end
      
      #
      # Ensures that the repository exists. If not, ask the user about creating
      # one in interactive mode; raises an error otherwise. Continues execution
      # with the block if required.
      #
      def ensure_repository(&block)
        if environment.repository_exists?
          block.call
        elsif environment.interactive?
          where = environment.friendly_repository_path
          msg = <<-EOF.gsub(/^\s*\| ?/, '')
          | DbAgile's repository #{where} does not exist. Maybe it's the first time you
          | lauch dba. Do you want to create a fresh repository now?
          EOF
          confirm(msg, "Have a look at 'dba help repo:create'"){
            # create it!
            say("Creating repository #{where}...")
            DbAgile::Core::Repository::create!(environment.repository_path)
            say("Repository has been successfully created.")
            
            # continue?
            msg = "Do you want to continue with previous command execution?"
            confirm(msg, &block)
          }
        else
          # to force an error
          environment.repository
        end
      end
      
      # Yields the block if the user confirms something and returns block 
      # execution. Returns nil otherwise
      #
      def confirm(msg, on_no_msg = nil)
        say("\n")
        say(msg, :magenta)
        answer = environment.ask(""){|q| q.validate = /^y(es)?|n(o)?|q(uit)?/i}
        case answer.strip
          when /^n/, /^q/
            say("\n")
            say(on_no_msg, :magenta) unless on_no_msg.nil?
          when /^y/
            yield
        end
      end

    end # class DbA
  end # class Command
end # module DbAgile