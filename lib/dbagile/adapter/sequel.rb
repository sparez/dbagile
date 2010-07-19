require 'dbagile/adapter/sequel/class_methods'
require 'dbagile/adapter/sequel/connection'
require 'dbagile/adapter/sequel/data/table_driven'
require 'dbagile/adapter/sequel/data/transaction_driven'
require 'dbagile/adapter/sequel/schema/table_driven'
require 'dbagile/adapter/sequel/schema/transaction_driven'
module DbAgile
  #
  # Implements the Adapter contract using Sequel.
  #
  class SequelAdapter < Adapter
    extend SequelAdapter::ClassMethods
    include SequelAdapter::Connection
    include SequelAdapter::Data::TableDriven
    include SequelAdapter::Data::TransactionDriven
    include SequelAdapter::Schema::TableDriven
    include SequelAdapter::Schema::TransactionDriven
    
    # Underlying database URI
    attr_reader :uri
    
    # Connection options
    attr_reader :options
    
    # Creates an adapter with a given uri
    def initialize(uri, options = {})
      @uri, @options = uri, options
    end
    
    # Returns the underlying Sequel::Database instance
    def db
      unless @db
        @db = ::Sequel.connect(uri)
        @db.logger = @options[:sequel_logger]
      end
      @db
    end
    
    # Asserts that a table exists or raises a NoSuchTableError
    def has_table!(name)
      raise NoSuchTableError, "No such table #{name}" unless has_table?(name)
    end
    
    # Asserts that a table does not exist or raises a TableAlreadyExistsError
    def not_has_table!(name)
      raise TableAlreadyExistsError, "No such table #{name}" if has_table?(name)
    end
    
  end # class SequelAdapter
end # module DbAgile
require 'dbagile/adapter/sequel/sequel_tracer'