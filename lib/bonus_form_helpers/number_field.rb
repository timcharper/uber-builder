module ActionView
  module Helpers
    module FormHelper
      def number_field(object_name, method, options={})
        InstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_number_field_tag("text", options)
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

  def to_number_field_tag(field_type, options = {})
    options = options.stringify_keys
    number_options = {
      :precision => options.delete("precision"),
      :separator => options.delete("separator") || ".",
      :delimiter => options.delete("delimiter") || ",",
      :unit => ""
    }
    
    # auto-detect type
    number_options[:precision] ||= 0 if column_type == :integer
    number_options[:precision] ||= column_scale if column_scale
    
    # generate the text tag
    options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
    options = DEFAULT_FIELD_OPTIONS.merge(options)
    options.delete("size")
    options["type"] = field_type
    
    
    big_value = BigDecimal(value_before_type_cast(object).to_s).to_s
    if number_options[:precision]
      parts = number_with_precision(big_value, number_options[:precision]).split(".")
    else
      parts = big_value.split(".")
    end
    
    parts[0] = number_with_delimiter(parts[0], number_options[:delimiter])
    options["value"] ||= parts * number_options[:separator]
    
    options["onchange"] = "$(this).previous().value = $F(this).replace(/[#{number_options[:delimiter]}#{number_options[:unit]}]/g, '').replace('#{number_options[:separator]}', '.'); " + options[:onchange].to_s
    add_default_name_and_id(options)
    
    # generate the hidden tag
    output = tag_without_error_wrapping("input", {
      "name" => options["name"],
      "value" => big_value,
      "type" => "hidden"
    })
    output << tag_without_error_wrapping("input", options)
    
    wrap_with_errors_if_needed(output)
  end
end