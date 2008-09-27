require File.dirname(__FILE__) + "/spec_helper.rb"

describe UberBuilder::TemplatedBuilder do
  before(:each) do
    @template = ActionView::Base.new
    @record = MockModel.new(:first_name => "Tim Harper", :balance => 1000.25, :age => 25, :long => 41.234, :lat => 40.123)
    @template.instance_variable_set("@record", @record)
    
    @builder = UberBuilder::TemplatedBuilder.new(:record, nil, @template, {}, lambda {})
    @builder.extend CaptureStubMethods
  end
  
  it "should output element outside of table" do
    output = @builder.text_field(:first_name)
    
    output.should == %!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!
  end
  
  it "should type cast to a static builder" do
    @static_builder = @builder.to_static
    @static_builder.text_field(:first_name).should == "Tim Harper"
  end
  
  describe "p layout" do
    it "should output p and label" do
      output = @builder.p {
        @builder.text_field(:first_name)
      }
      output.should include('<p>')
      output.should include('<label for="record_first_name">First name:</label><br />')
      output.should include(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!)
      output.should include('</p>')
    end
  end
  
  describe "div layout" do
    it "should output div and label" do
      output = @builder.div {
        @builder.text_field(:first_name)
      }
      output.should include('<div>')
      output.should include('<label for="record_first_name">First name:</label><br />')
      output.should include(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!)
      output.should include('</div>')
    end
    
    it "should receive :div_options" do
      output = @builder.div {
        @builder.text_field(:first_name, :div_options => {:class => "hello"})
      }
      output.should include('<div class="hello">')
    end
  end
  
  describe "table layout" do
    it "should output table and label" do
      output = @builder.table {
        @builder.text_field(:first_name)
      }
    
      output.should include('<table class="form"><tr>')
      output.should include('<td class="label"><label for="record_first_name">First name:</label></td>')
      output.should include(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!)
    end
  end
  
  describe "ul layout" do
    it "should output ul and label" do
      output = @builder.ul {
        @builder.text_field(:first_name)
      }
      output.should include('<ul class="form">')
      output.should include('<li><label for="record_first_name">First name:</label>')
      output.should include(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!)
      output.should include('</li></ul>')
    end
  end
  
  describe "fields" do
    it "should number retrieves defaults from model" do
      @record.age = 1234
      values = extract_values(@builder.number_field(:age))
      values[0].should == "1234"
      values[1].should == "1,234"
    
      @record.long = 1234.12345
      values = extract_values(@builder.number_field(:long))
      values[0].should == "1234.123"
      values[1].should == "1,234.123"
    end
    
    describe "number field" do
      before(:each) do
        @record.value = "1000000000000.1234567890000"
      end
      
      it "should output a number field using no commas in the hidden field, and commas in the text input" do
        values = extract_values(@builder.number_field(:value))
        values.should == ["1000000000000.123456789", "1,000,000,000,000.123456789"]
      end
      
      it "should respect the precision field" do
        values = extract_values(@builder.number_field(:value, :precision => 2))
        values.should == ["1000000000000.12", "1,000,000,000,000.12"]
    
        values = extract_values(@builder.number_field(:value, :precision => 0))
        values.should == ["1000000000000", "1,000,000,000,000"]
      end
      
      it "should number__nil_value__returns_nothing" do
        @record.value = nil
        extract_values(@builder.number_field(:value, :precision => 2)).should == ["", ""]
        @record.balance = nil
        extract_values(@builder.number_field(:balance, :precision => 2)).should == ["", ""]
      end
    end
    
    describe "currency field" do
      before(:each) do
        @record.value = 1000.25
      end
      
      it "should default to using a decimal for float fields" do
        @record.balance = 123.345
        values = extract_values(@builder.currency_field(:balance))
        values.should == ["123.35", "$123.35"]
      end
      
      it "should default to not use decimals for integer fields" do
        @record.int_balance = 1234
        values = extract_values(@builder.currency_field(:int_balance))
        values.should == ["1234", "$1,234"]
      end
      
      it "should format a currency with a comma, decimal, and dollar sign" do
        values = extract_values(@builder.currency_field(:value))
        values.should == ["1000.25", "$1,000.25"]
      end
      
      it "should respect localization fields" do
        values = extract_values(@builder.currency_field(:value, :unit => "Y", :delimiter => ".", :separator => ","))
        values.should == ["1000.25", "Y1.000,25"]
      end
      
      it "should return nothing for nil values" do
        @record.value = nil
        extract_values(@builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2)).should == ["", ""]
        @record.balance = nil
        extract_values(@builder.currency_field(:balance, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2)).should == ["", ""]
      end
    end
  end
protected
  def extract_values(output)
    output.scan(/value="([^"]*)"/).map(&:first)
  end
end