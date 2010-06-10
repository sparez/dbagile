require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/engine'
describe "DbAgile::Engine::Signature#match" do
  
  context "when called on an empty signature" do
    let(:signature){ DbAgile::Engine::Signature.new }
    specify{
      signature.match([]).should == {}
      signature.match(["hello"]).should be_nil
    }
  end
  
  context "when called on a signature with a class" do
    let(:signature){ 
      DbAgile::Engine::Signature.new{ add_argument :URI, String }
    }
    specify{
      signature.match([]).should be_nil
      signature.match(["hello"]).should == {:URI => "hello"}
      signature.match(["hello", "hello2"]).should be_nil
      signature.match([12]).should be_nil
    }
  end
  
  context "when called on a signature with a regexp" do
    let(:signature){ 
      DbAgile::Engine::Signature.new{ add_argument :URI, /^[0-9]+$/ }
    }
    specify{
      signature.match([]).should be_nil
      signature.match(["1234"]).should == {:URI => "1234"}
      signature.match(["hello"]).should be_nil
      signature.match([12]).should be_nil
    }
  end
  
  context "when called on a signature with a proc" do
    let(:signature){ 
      DbAgile::Engine::Signature.new{ add_argument(:URI){|uri| /^[0-9]+$/ =~ uri} }
    }
    specify{
      signature.match([]).should be_nil
      signature.match(["1234"]).should == {:URI => "1234"}
      signature.match(["hello"]).should be_nil
      signature.match([12]).should be_nil
    }
  end
  
  context "when called on a signature with a proc object" do
    let(:signature){ 
      DbAgile::Engine::Signature.new{ add_argument(:URI, lambda{|uri| /^[0-9]+$/ =~ uri}) }
    }
    specify{
      signature.match([]).should be_nil
      signature.match(["1234"]).should == {:URI => "1234"}
      signature.match(["hello"]).should be_nil
      signature.match([12]).should be_nil
    }
  end
  
  context "when called on the sql command signature " do
    let(:signature){ 
      DbAgile::Engine::Signature.new{ add_argument(:QUERY, /^\s*(select|SELECT)/) }
    }
    specify{
      signature.arguments.size.should == 1
      signature.match(["SELECT * FROM TABLE"]).should == {:QUERY => "SELECT * FROM TABLE"}
    }
  end
end