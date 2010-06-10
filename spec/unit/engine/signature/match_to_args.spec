require File.expand_path('../../../../spec_helper', __FILE__)
require 'flexidb/engine'
describe "FlexiDB::Engine::Signature#match_to_args" do
  
  let(:signature){
    FlexiDB::Engine::Signature.new{
      add_argument(:NAME, String)
      add_argument(:AGE, Integer)
    }
  }
  
  context "when called on a simple signature" do
    let(:match){ signature.match(["hello", 12]) }
    subject{ signature.match_to_args(match) }
    it{ should == ["hello", 12] }
  end
  
end