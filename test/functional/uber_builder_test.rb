require File.dirname(__FILE__) + "/../test_helper.rb"
require 'ostruct'

module ActionView::Helpers::CaptureHelper
  def capture(&block)
    yield
  end
end
module ActionView::Helpers::CaptureHelper
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
  end
  
  def test__builder__outside_of_table__should_output_element
    output = @builder.text_field(:first_name)
    
    assert_equal(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!, output)
  end
  
  def test__builder__table__should_output_table_and_label
    output = @builder.table {
      @builder.text_field(:first_name)
    }
    
    assert_match('<table class="form">', output)
    assert_match('<label for="record_first_name">First name:</label>', output)
    assert_match(%!<input id="record_first_name" name="record[first_name]" size="30" type="text" value="Tim Harper" />!, output)
  end
end