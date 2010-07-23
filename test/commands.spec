require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile::Command::API /" do
  
  # Path to an empty configuration file
  let(:empty_config_path){ File.expand_path('../fixtures/configs/empty_config.dba', __FILE__) }
  
  # The environment to use
  let(:dba){ DbAgile::Command::API.new(DbAgile::Fixtures::environment) }
  
  # Clean everything after tests
  after(:all) { FileUtils.rm_rf(empty_config_path) }
    
  # -- Configuration
  describe "configuration commands (touching) /" do 
  
    # Remove empty config between all test
    before       {  dba.config_file_path = empty_config_path }
    before(:each){ FileUtils.rm_rf(empty_config_path)        }
  
    describe "config:add /" do
      it_should_behave_like "The config:add command" 
    end
  
    describe "config:rm /" do
      it_should_behave_like "The config:rm command" 
    end
  
    describe "config:use /" do
      it_should_behave_like "The config:use command" 
    end
  
  end # -- Configuration
  
  # -- Configuration
  describe "configuration commands (non touching) /" do 
  
    # Make usage of sqlite for these tests
    before { dba.config_use %{sqlite} }
  
    describe "config:list /" do
      it_should_behave_like "The config:list command" 
    end
  
    describe "config:ping /" do
      it_should_behave_like "The config:ping command" 
    end

  end # -- Configuration
  
  # -- Input/Output
  describe "bulk commands /" do 

    # Make usage of sqlite for these tests
    before{ 
      dba.config_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "show /" do
      it_should_behave_like "The show command" 
    end

    describe "bulk:export /" do
      it_should_behave_like "The bulk:export command" 
    end

    describe "bulk:import /" do
      it_should_behave_like "The bulk:import command" 
    end

  end # -- Input/Output
  
  # -- Query
  describe "query commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.config_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "sql /" do
      it_should_behave_like "The sql command" 
    end

  end # -- Query
  
  # -- Schema
  describe "schema commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.config_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "schema:heading /" do
      it_should_behave_like "The schema:heading command" 
    end

    describe "schema:drop /" do
      it_should_behave_like "The schema:drop command" 
    end

  end # -- Schema
  
end
