module ActionView
  module Helpers
    module FormHelper
      def currency_field(object_name, method, options={})
        InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_currency_field_tag("text", options)
      end
    end
    
    class FormBuilder
      def currency_field(method, options = {})
        @template.currency_field(@object_name, method, options.merge(:object => @object))
      end
      self.field_helpers << :currency_field
    end
  end
end

class ActionView::Helpers::InstanceTag
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers
  include NumberFieldHelpers
  
  def to_currency_field_tag(field_type, options = {})
    options = options.stringify_keys
    currency_options = extract_number_field_options(options, column_type, column_scale)
    
    str_value = value_before_type_cast(object).to_s
    str_value = BigDecimal(str_value).to_s unless str_value.blank?
    
    # generate the text tag
    options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
    options = DEFAULT_FIELD_OPTIONS.merge(options)
    options.delete("size")
    options["type"] = field_type
    options["value"] ||= number_to_currency(str_value.to_s, currency_options)
    options["onchange"] = "$(this).previous().value = $F(this).replace(/[#{currency_options[:delimiter]}#{currency_options[:unit]}]/g, '').replace('#{currency_options[:separator]}', '.'); " + options[:onchange].to_s
    add_default_name_and_id(options)
    
    # generate the hidden tag
    output = tag_without_error_wrapping("input", {
      "name" => options["name"],
      "value" => currency_options[:precision] ? number_with_precision(str_value, currency_options[:precision]) : str_value,
      "type" => "hidden"
    })
    output << tag_without_error_wrapping("input", options)
    
    wrap_with_errors_if_needed(output)
  end
end