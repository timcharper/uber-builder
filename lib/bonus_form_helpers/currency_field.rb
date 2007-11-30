module ActionView
  module Helpers
    module FormHelper
      def currency_field(object_name, method, options={})
        InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_currency_field_tag("text", options)
#        output << hidden_field(object, method, options)
#        output << text_field(object, method, options)
#        output
      end
    end
    
    class FormBuilder
      def currency_field(method, options = {})
        @template.currency_field(@object_name, method, options.merge(:object => @object))
      end
    end
  end
end

#

class ActionView::Helpers::InstanceTag
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers
  
  def to_currency_field_tag(field_type, options = {})
    options = options.stringify_keys
    
    currency_options = {
      :precision => options.delete("precision") || 2,
      :unit => options.delete("unit") || "$",
      :separator => options.delete("separator") || ".",
      :delimiter => options.delete("delimiter") || ","
    }
    
    # generate the text tag
    options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
    options = DEFAULT_FIELD_OPTIONS.merge(options)
    options.delete("size")
    options["type"] = field_type
    options["value"] ||= number_to_currency(value_before_type_cast(object).to_f, currency_options)
    options["onchange"] = "$(this).previous().value = $F(this).replace(/[#{currency_options[:delimiter]}#{currency_options[:unit]}]/g, '').replace('#{currency_options[:separator]}', '.'); " + options[:onchange].to_s
    add_default_name_and_id(options)
    
    # generate the hidden tag
    output = tag_without_error_wrapping("input", {
      "name" => options["name"],
      "value" => value_before_type_cast(object),
      "type" => "hidden"
    })
    output << tag_without_error_wrapping("input", options)
    
    wrap_with_errors_if_needed(output)
  end
end