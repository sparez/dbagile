module DbAgile
  module Core
    class Schema
      module Logical
        class Heading
        
          # Heading attributes
          attr_reader :attributes
        
          # Creates a heading instance
          def initialize(attributes = {})
            @attributes = attributes
          end
        
          # Returns an attribute definition
          def [](name)
            self.attributes[name]
          end
        
          # Sets an attribute definition
          def []=(name, definition)
            self.attributes[name] = definition
          end
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            Schema::Coercion::unsymbolize_hash(attributes).to_yaml(opts)
          end
        
        end # class Heading
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
