module DbAgile
  class Adapter
    module Delegate
      
      # The delegate to use
      attr_accessor :delegate
    
      ::DbAgile::Adapter::Contract.instance_methods(false).each do |meth|
        module_eval <<-EOF
          def #{meth}(*args, &block)
            delegate.#{meth}(*args, &block)
          end
        EOF
      end
    
    end # module Delegate
  end # class Adapter
end # module DbAgile