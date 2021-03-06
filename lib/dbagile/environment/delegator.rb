module DbAgile
  class Environment
    #
    # Helper to be an environment delegator
    #
    module Delegator
      
      [
        #
        :interactive?,
        :interactive!,
        :interactive=,
        #
        :flush,
        :say,
        :display,
        #
        :console_width,
        :console_width=,
        #
        :repository_path,
        :repository_path=,
        :repository,
        #
        :input_buffer,
        :input_buffer=,
        :output_buffer,
        :output_buffer=,
        :asking_buffer,
        :asking_buffer=,
        :message_buffer,
        :message_buffer=,
        #
        :with_repository,
        :with_database,
        :with_current_database,
        #
        :with_connection,
        :with_current_connection
      ].each do |method_name|
        if method_name.to_s =~ /=$/
          code = <<-EOF
            def #{method_name}(value)
              environment.#{method_name} value
            end
          EOF
        else
          code = <<-EOF
            def #{method_name}(*args, &block)
              environment.#{method_name}(*args, &block)
            end
          EOF
        end
        module_eval(code)
      end
    
    end # module Delegator
  end # class Environment
end # module DbAgile