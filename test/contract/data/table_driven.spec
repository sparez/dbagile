shared_examples_for "A Contract::Data::TableDriven" do

  ::DbAgile::Contract::Data::TableDriven.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  Dir[File.expand_path('../table_driven/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end