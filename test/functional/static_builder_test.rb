require File.dirname(__FILE__) + "/../test_helper.rb"

class StaticBuilderTest < Test::Unit::TestCase
  def setup
    @template = ActionView::Base.new
    @record = MockModel.new(:first_name => "Tim Harper", :balance => 1000.25, :age => 25, :long => 41.234, :lat => 40.123)
    @template.instance_variable_set("@record", @record)
    
    @builder = StaticBuilder.new(:record, nil, @template, {}, lambda {})
    @builder.extend CaptureStubMethods
  end
  
  def test__builder__outside_of_table__should_output_element
    output = @builder.text_field(:first_name)
    
    assert_equal("Tim Harper", output)
  end
  
  def test__builder__table__should_output_table_and_label
    output = @builder.table {
      @builder.text_field(:first_name)
    }
    
    assert_match('<table class="form"><tr>', output)
    assert_match('<td class="label"><label for="record_first_name">First name:</label></td>', output)
    assert_match("Tim Harper", output)
  end
  
  def test__builder__ul__should_output_ul_and_label
    output = @builder.ul {
      @builder.text_field(:first_name)
    }
    assert_match('<ul class="form">', output)
    assert_match('<li><label for="record_first_name">First name:</label>', output)
    assert_match("Tim Harper", output)
    assert_match('</li></ul>', output)
  end
  
  def test__currency__retrieves_defaults_from_model
    @record.balance = 123.345
    assert_equal("$123.35", @builder.currency_field(:balance))
    
    @record.int_balance = 1234
    
    assert_equal("$1,234", @builder.currency_field(:int_balance))
  end
  
  def test__number__retrieves_defaults_from_model
    @record.age = 1234
#    dbg
    assert_equal("1,234", @builder.number_field(:age))
    
    @record.long = 1234.12345
    assert_equal("1,234.123", @builder.number_field(:long))
    
  end
  
  def test__number_field
    @record.value = "1000000000000.1234567890000"
    
    assert_equal("1,000,000,000,000.123456789", @builder.number_field(:value))
    assert_equal("1,000,000,000,000.12", @builder.number_field(:value, :precision => 2))
    assert_equal("1,000,000,000,000", @builder.number_field(:value, :precision => 0))
  end
  
  def test__currency_field
    @record.value = 1000.25
    assert_equal("$1,000.25", @builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => "."))
    output = @builder.currency_field(:value, :unit => "Y", :delimiter => ".", :separator => ",")
    assert_equal("Y1.000,25", output)
  end
  
end