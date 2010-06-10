require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.add_columns" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on a non existing table" do
      subject{ lambda{ adapter.add_columns(:no_such_table, {:id => Integer}) } }
      it{ should raise_error(ArgumentError) }
    end

    describe "When called on an existing table" do
      subject{ adapter.add_columns(:dbagile, {:hello => Integer, :name => String}) }
      specify{ 
        subject.should be_true
        adapter.column_names(:dbagile, true).should == [:hello, :id, :name, :schema, :version]
      }
    end
  
  end

end