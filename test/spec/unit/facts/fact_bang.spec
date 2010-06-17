require File.expand_path('../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts#fact!" do
  
  let(:uri){ "memory://test.db" }
  let(:factdb){ DbAgile::Facts::connect(uri) }
  let(:supplier_key){ { :'s#' => 1 } }
  let(:supplier){ {:'s#' => 1, :name => "Clark"} }
  
  
  context "when called with a name" do
    specify{ 
      factdb.fact!(:supplier, supplier).should == supplier_key
      factdb.connection.dataset(:supplier).to_a.should == [ supplier ]
    }
  end
  
  context "when called without a name" do
    specify{ 
      factdb.fact!(supplier).should == supplier_key
      factdb.connection.dataset(:'s#').to_a.should == [ supplier ]
    }
  end
  
  context "when called two times with the same fact" do
    specify{ 
      factdb.fact!(supplier).should == supplier_key
      factdb.fact!(supplier).should == supplier_key
      factdb.connection.dataset(:'s#').to_a.should == [ supplier ]
    }
  end
  
end

