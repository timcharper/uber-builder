require File.dirname(__FILE__) + "/spec_helper.rb"

describe Builders::StaticBuilder do
  before(:each) do
    @template = ActionView::Base.new
    @record = MockModel.new(:first_name => "Tim Harper", :balance => 1000.25, :age => 25, :long => 41.234, :lat => 40.123)
    @template.instance_variable_set("@record", @record)
    
    @builder = Builders::StaticBuilder.new(:record, nil, @template, {}, lambda {})
    @builder.extend CaptureStubMethods
  end
  
  it "should builder__outside_of_table__should_output_element" do
    output = @builder.text_field(:first_name)
    
    output.should == "Tim Harper"
  end
  
  it "should builder__table__should_output_table_and_label" do
    output = @builder.table {
      @builder.text_field(:first_name)
    }
    
    output.should include('<table class="form"><tr>')
    output.should include('<td class="label"><label for="record_first_name">First name:</label></td>')
    output.should include("Tim Harper")
  end
  
  it "should builder__ul__should_output_ul_and_label" do
    output = @builder.ul {
      @builder.text_field(:first_name)
    }
    output.should include('<ul class="form">')
    output.should include('<li><label for="record_first_name">First name:</label>')
    output.should include("Tim Harper")
    output.should include('</li></ul>')
  end
  
  it "should currency__retrieves_defaults_from_model" do
    @record.balance = 123.345
    @builder.currency_field(:balance).should == "$123.35"
    
    @record.int_balance = 1234
    
    @builder.currency_field(:int_balance).should == "$1,234"
  end
  
  it "should number__retrieves_defaults_from_model" do
    @record.age = 1234
    @builder.number_field(:age).should == "1,234"
    
    @record.long = 1234.12345
    @builder.number_field(:long).should == "1,234.123"
  end
  
  it "should number_field" do
    @record.value = "1000000000000.1234567890000"
    
    @builder.number_field(:value).should == "1,000,000,000,000.123456789"
    @builder.number_field(:value, :precision => 2).should == "1,000,000,000,000.12"
    @builder.number_field(:value, :precision => 0).should == "1,000,000,000,000"
  end
  
  it "should currency_field" do
    @record.value = 1000.25
    @builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => ".").should == "$1,000.25"
    output = @builder.currency_field(:value, :unit => "Y", :delimiter => ".", :separator => ",")
    output.should == "Y1.000,25"
  end
  
  it "should currency__nil_value__returns_nothing" do
    @record.value = nil
    @builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2).should == ""
    @record.balance = nil
    @builder.currency_field(:balance, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2).should == ""
  end
  
  it "should number__nil_value__returns_nothing" do
    @record.value = nil
    @builder.number_field(:value, :precision => 2).should == ""
    @record.balance = nil
    @builder.number_field(:balance, :precision => 2).should == ""
  end
  
end