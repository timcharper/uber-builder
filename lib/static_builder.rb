module UberBuilder::StaticBuilderMethods
  ActionView::Helpers::FormBuilder.field_helpers.each do |selector|
    define_method(selector) do |*args|
      object.send(args.first)
    end
  end

  def select(field, choices, options = {}, html_options = {})
    value = object.send(field)
    choices.each do |choice|
      if choice.is_a?(Array)
        label, index = choice
      else
        label, index = choice, choice
      end
      return label if index == value
    end

    ""
  end

  def [](index)
    object.send(index)
  end

  def radio_button_list(method, choices, options = {})
    element_value=self[method]

    choices.each{ |choice|
      if choice.is_a? Array
        label=choice[1]
        value=choice[0]
      else
        label=choice.to_s
        value=choice.to_s
      end

      if element_value==value
        return label
      end
    }

    "-"
  end

  def check_box(method, options = {})
    element_value=self[method]

    "<image src='/images/checkbox_#{element_value ? "on" : "off"}.gif' /> "

    #    MyHelper.new.check_box_tag "checkbox", :checked => self[method]?"true":"false", :readonly=>true
  end


  def text_area(method, options = {})
    value = self[method]

    "<pre>#{value}</pre>"
  end

  def currency_field(method, options = {})
    currency_options = extract_number_field_options(options.stringify_keys, column_type(method), column_scale(method))
    number_to_currency(self[method], currency_options).to_s
  end

  def number_field(method, options = {})
    number_options = extract_number_field_options(options.stringify_keys, column_type(method), column_scale(method))
    value = self[method].to_s
    value = BigDecimal(value).to_s unless value.blank?
    apply_precision_and_delimiter(value, number_options).to_s
  end
end

class UberBuilder::StaticBuilder
  attr_accessor :object_name, :object
  include NumberFieldHelpers

  def initialize(object_name, object, template, options, proc)
    @object_name, @object, @template, @options, @proc = object_name, object, template, options, proc
  end
  
  def [](index)
    object.send(index)
  end
  

  include ActionView::Helpers::AssetTagHelper
  include UberBuilder::StaticBuilderMethods
  include UberBuilder::TemplatedMethods

  def object
    @object ||= @template.instance_variable_get("@#{@object_name}")
  end
  
protected  
  def columns_hash
    @columns_hash ||= object.class.respond_to?(:columns_hash) && object.class.columns_hash
  end
  
  def column_info(column)
    columns_hash && columns_hash[column.to_s]
  end
  
  def column_type(column)
    ci = column_info(column)
    ci && ci.type
  end
  
  def column_scale(column)
    ci = column_info(column)
    ci && ci.scale
  end
end
