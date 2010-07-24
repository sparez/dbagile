module DbAgile
  module Core
    module Schema
      class Logical
        class ForeignKey < Constraint
        
          # Returns source table attributes
          def source_attributes
            definition[:source]
          end
          
          # Returns the referenced table
          def referenced
            definition[:references]
          end
        
          # Returns target table attributes
          def target_attributes
            definition[:target]
          end
          
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              source = Schema::Builder::Coercion::unsymbolize_array(definition[:source])
              target = Schema::Builder::Coercion::unsymbolize_array(definition[:target])
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('type', definition[:type])
                map.add('references', definition[:references].to_s)
                map.add('source', source)
                map.add('target', target)
              end
            }
          end

        end # class ForeignKey
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
