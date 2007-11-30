require File.dirname(__FILE__) + "/../test_helper.rb"

class UberBuilderTest < Test::Unit::TestCase
  def setup
    @template = ActionView::Base.new
    @record = MockModel.new(:first_name => "Tim Harper", :balance => 1000.25, :age => 25, :long => 41.234, :lat => 40.123)
    @template.instance_variable_set("@record", @record)
    
    @builder = Builders::TemplatedBuilder.new(:record, nil, @template, {}, lambda {})
    @builder.extend CaptureStubMethods
  end
  
  def test__builder__outside_of_table__should_output_element
    output = @builder.text_field(:first_name)
    
    assert_equal(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!, output)
  end
  
  def test__builder__table__should_output_table_and_label
    output = @builder.table {
      @builder.text_field(:first_name)
    }
    
    assert_match('<table class="form"><tr>', output)
    assert_match('<td class="label"><label for="record_first_name">First name:</label></td>', output)
    assert_match(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!, output)
  end
  
  def test__builder__ul__should_output_ul_and_label
    output = @builder.ul {
      @builder.text_field(:first_name)
    }
    assert_match('<ul class="form">', output)
    assert_match('<li><label for="record_first_name">First name:</label>', output)
    assert_match(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!, output)
    assert_match('</li></ul>', output)
  end
  
  def test__currency__retrieves_defaults_from_model
    @record.balance = 123.345
    values = values_from(@builder.currency_field(:balance))
    
    assert_equal("123.35", values[0])
    assert_equal("$123.35", values[1])
    
    @record.int_balance = 1234
    
    values = values_from(@builder.currency_field(:int_balance))
    assert_equal("1234", values[0])
    assert_equal("$1,234", values[1])
  end
  
  def test__number__retrieves_defaults_from_model
    @record.age = 1234
    values = values_from(@builder.number_field(:age))
    assert_equal("1234", values[0])
    assert_equal("1,234", values[1])
    
    @record.long = 1234.12345
    values = values_from(@builder.number_field(:long))
    assert_equal("1234.123", values[0])
    assert_equal("1,234.123", values[1])
    
  end
  
  def test__number_field
    @record.value = "1000000000000.1234567890000"
    values = values_from(@builder.number_field(:value))
    assert_equal(["1000000000000.123456789", "1,000,000,000,000.123456789"], values)
    
    values = values_from(@builder.number_field(:value, :precision => 2))
    assert_equal(["1000000000000.12", "1,000,000,000,000.12"], values)
    
    values = values_from(@builder.number_field(:value, :precision => 0))
    assert_equal(["1000000000000", "1,000,000,000,000"], values)
  end
  
  def test__currency_field
    @record.value = 1000.25
    assert_match("$1,000.25", @builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => "."))
    output = @builder.currency_field(:value, :unit => "Y", :delimiter => ".", :separator => ",")
    assert_match("Y1.000,25", output)
  end
  
  def test__to_static__should_convert
    @static_builder = @builder.to_static
    assert_equal("Tim Harper", @static_builder.text_field(:first_name))
  end
  
  def test__currency__nil_value__returns_nothing
    @record.value = nil
    assert_equal(["", ""], values_from(@builder.currency_field(:value, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2)))
    @record.balance = nil
    assert_equal(["", ""], values_from(@builder.currency_field(:balance, :unit => "$", :delimiter => ",", :separator => ".", :precision => 2)))
  end
  
  def test__number__nil_value__returns_nothing
    @record.value = nil
    assert_equal(["", ""], values_from(@builder.number_field(:value, :precision => 2)))
    @record.balance = nil
    assert_equal(["", ""], values_from(@builder.number_field(:balance, :precision => 2)))
  end
protected
  def values_from(output)
    output.scan(/value="([^"]*)"/).map(&:first)
  end
end