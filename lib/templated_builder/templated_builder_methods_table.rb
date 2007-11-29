module Builders
  module TemplatedBuilderMethods
  protected
    def table_generic_field(fieldname, field, options = {})
      return field if @bypass_for_block
      
      row_options = options.delete(:row)
      
      if options[:prefix]
        field = options[:prefix] + field.to_s
      end 
      if options[:suffix]
        field = field.to_s + options[:suffix]
      end
      
      label_text = options[:label_text]
      label_text = "*#{label_text}" if options[:required]
      
      unless label_text.blank?
        if options[:label] == :after
          tr(td('') + td(field + " " + table_label(label_text, "#{@object_name}_#{fieldname}", true)), row_options )
        else
          tr(
            td(table_label(label_text, "#{@object_name}_#{fieldname}"), :class => :label) + td(field),
            row_options
          ) 
        end
      else # No label
        tr(td(field, :colspan => 2, :style => "text-align: right;") )
      end
    end
    
    def tr(content, options = {})
      @template.content_tag 'tr', content, options
    end
    
    def td(content, options = {})
      @template.content_tag 'td', content, options
    end
    
    def table_label(text, for_field, after = false)
      @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
    end
    
  end
end
