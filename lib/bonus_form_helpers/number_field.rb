module ActionView
  module Helpers
    module FormHelper
      def number_field(object_name, method, options={})

        InstanceTag.new(object_name, method, self, options.delete(:object)).to_number_field_tag("text", options)
      end
    end
    
    class FormBuilder
      def number_field(method, options = {})
        @template.number_field(@object_name, method, options.merge(:object => @object))
      end
      self.field_helpers << :currency_field
    end
  end
end

class ActionView::Helpers::InstanceTag
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers
  include NumberFieldHelpers
  def to_number_field_tag(field_type, options = {})
    options = options.stringify_keys
    
    number_options = extract_number_field_options(options, column_type, column_scale)
    
    # generate the text tag
    options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
    options = DEFAULT_FIELD_OPTIONS.merge(options)
    options.delete("size")
    options["type"] = field_type

    str_value = value_before_type_cast(object).to_s
    str_value = BigDecimal(str_value).to_s unless str_value.blank?
    
    options["value"] ||= apply_precision_and_delimiter(str_value, number_options)
    
    options["onchange"] = "$(this).previous().value = $F(this).replace(/[#{number_options[:delimiter]}#{number_options[:unit]}]/g, '').replace('#{number_options[:separator]}', '.'); " + options[:onchange].to_s
    add_default_name_and_id(options)
    
    # generate the hidden tag
    output = tag("input", {
      "name" => options["name"],
      "value" => apply_precision(str_value, number_options),
      "type" => "hidden"
    })
    output << tag("input", options)
    
    wrap_with_errors_if_needed(output)
  end
end
