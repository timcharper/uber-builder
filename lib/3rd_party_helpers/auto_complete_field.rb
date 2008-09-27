module UberBuilder
  class StaticBuilder
    def auto_complete_text_field(field, options = {})
      options.delete(:url)
      text_field(field, options)
    end
  end
  
  module TemplatedMethods
    def auto_complete_text_field(field, options = {})
      url = options.delete(:url)
      field_id = options[:id] || "#{self.object_name}_#{field}"
      options[:autocomplete]=false
      tabular_options = extract_tabular_options(field, options)
      temp, @bypass_for_block = @bypass_for_block, true
      output = text_field(field, options)
      @bypass_for_block = temp
      
      output << @template.content_tag(:div, "", :class => "auto_complete", :id => "#{field_id}_auto_complete")
      output << @template.indicator(field_id.to_s)
      output << @template.auto_complete_field(field_id,
        :url => url,
        :indicator => "#{field_id}_indicator")
      generic_field(field, output, tabular_options )
    end
  end
end
