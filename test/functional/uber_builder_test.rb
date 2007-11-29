require File.dirname(__FILE__) + "/../test_helper.rb"
require 'ostruct'

module CaptureStubMethods
  def capture(&block)
    yield
  end
  def concat(text, *args)
    @concat_output||=""
    @concat_output << text.to_s
  end
end

class UberBuilderTest < Test::Unit::TestCase
  def setup
    @template = ActionView::Base.new
    @record = OpenStruct.new(:first_name => "Tim Harper")
    @template.instance_variable_set("@record", @record)
    
    @builder = TemplatedBuilder.new(:record, nil, @template, {}, lambda {})
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
end