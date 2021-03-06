module DbAgile

  class Error < StandardError; end

  # Raised when something goes wrong with a schema
  class SchemaError < DbAgile::Error; end

  # 
  # Raised when something goes really wrong with a schema. This certainly
  # indicates a bug inside DbAgile, please report!
  #
  # Something wrong happened in DbAgile when using your schema. Please report 
  # the error to developers:
  # #{cause.message}
  # #{cause.backtrace}
  #
  class SchemaInternalError < DbAgile::SchemaError; end
  
  # 
  # Raised when an operation on schemas fails because of conflicts (typically
  # a merge operation without resolver block)
  #
  # Database schema conflict between #{left} and #{right}
  #
  class SchemaConflictError < DbAgile::SchemaError 
    
    # Left schema object
    attr_reader :left
    
    # Right schema object
    attr_reader :right
    
    # Part name
    attr_reader :part_name
    
    # Creates an error instance
    def initialize(left, right, part_name = nil)
      @left, @right = left, right
      @part_name = part_name
      super(left.parent)
    end
    
    def message
      "Schema conflict occured on #{left} : #{part_name}"
    end
    
  end # class SchemaConflictError
  
  #
  # Raised when something goes wrong with a schema during a builder 
  # execution.
  #
  # As schema parsing is often made on YAML files, any error at builder
  # stage is considered a syntax error. However, it includes schema
  # type checking, which is not that syntactic!
  #
  # Syntax error when parsing #{schema_file}: #{cause.message}
  #
  class SchemaSyntaxError < DbAgile::SchemaError; end
  
  # 
  # Raised when a schema is semantically not correct.
  #
  class SchemaSemanticsError < DbAgile::SchemaError
    
    # Object-specific error tree
    InvalidLogicalSchema          =                           0x1000000          # 
      InvalidRelvar               = InvalidLogicalSchema  |     0x0100000        #
        InvalidHeading            = InvalidRelvar         |       0x0010000      #
          UnsupportedEmptyHeading = InvalidHeading        |         0x0001000    # schema_object=Heading
          InvalidAttribute        = InvalidHeading        |         0x0002000    #
            InvalidDefaultValue   = InvalidAttribute      |           0x0000100  # schema_object=Attribute
        InvalidConstraints        = InvalidRelvar         |       0x0020000      # 
          MissingPrimaryKey       = InvalidConstraints    |         0x0001000    # schema_object=Relvar
          InvalidConstraint       = InvalidConstraints    |         0x0002000    # schema_object=Constraint
            InvalidCandidateKey   = InvalidConstraint     |           0x0000100  # schema_object=CandidateKey
            InvalidForeignKey     = InvalidConstraint     |           0x0000200  # schema_object=ForeignKey
    InvalidPhysicalSchema         =                           0x2000000
      InvalidIndexes              = InvalidPhysicalSchema |     0x0100000        #
        InvalidIndex              = InvalidIndexes        |       0x0010000      #
      
    # General flags  
    NoSuchRelvar                   = 0x0000001  # :relvar_name
    NoSuchRelvarAttributes         = 0x0000002  # :relvar_name, :attributes
    NoSuchCandidateKey             = 0x0000004  # :constraint_name
    AttributeMismatch              = 0x0000008  # 
    TargetKeyMismatch              = 0x0000010  # 
    
    # User-defined messages
    MESSAGE_KEYS = [ 
      InvalidDefaultValue, 
      UnsupportedEmptyHeading, 
      MissingPrimaryKey,
      InvalidConstraint,
      
      InvalidIndex,
      
      NoSuchRelvar,
      NoSuchRelvarAttributes,
      NoSuchCandidateKey,
      AttributeMismatch,
      TargetKeyMismatch
    ]
    MESSAGE_VALUES = [
      'invalid default value \'#{schema_object.default_value}\' on #{schema_object}',
      'relvar #{schema_object.relation_variable.name} has an empty heading (unsupported so far)',
      'relvar #{schema_object.name} has no primary key',
      'invalid constraint #{schema_object.name} on #{schema_object.relation_variable.name}',
      'invalid index #{schema_object.name}',
      'no such relvar #{args[:relvar_name]}',
      'no such attributes #{args[:attributes].join(\',\')}',
      'no such candidate key #{args[:constraint_name]}',
      'attribute mismatch',
      'target key mismatch'
    ]
      
    # Involved schema object
    attr_reader :schema
    
    # Collected semantical errors
    attr_reader :errors
    
    # Creates an error instance
    def initialize(schema)
      @schema = schema
      @errors = []
    end
    
    # Converts an error to a message
    def error_to_message(schema_object, error_code, args = {})
      buffer = []
      MESSAGE_KEYS.each_with_index{|msg_key, index|
        next unless msg_key & error_code == msg_key
        buffer << Kernel.eval('"' + MESSAGE_VALUES[index] + '"', binding)
      }
      buffer.join(', ')
    end
    
    # Returns a friendly message
    def message(long = false)
      buffer = "Schema #{schema.schema_identifier} contains errors"
      if long
        buffer << ":\n"
        error_messages.each{|m| buffer << "  * " << m << "\n"}
      end
      buffer
    end
    
    # Returns an arry of error messages
    def error_messages
      errors.collect{|e|error_to_message(*e)}
    end
    
    # Returns number of sub errors
    def size
      errors.size
    end
    
    # Is this error empty (no semantics error, then)
    def empty?
      @errors.empty?
    end
    
    # Adds a semantics error
    def add_error(object, error_code, args = {})
      @errors << [object, error_code, args]
    end
    
  end # class SchemaSemanticsError
  
end # module DbAgile