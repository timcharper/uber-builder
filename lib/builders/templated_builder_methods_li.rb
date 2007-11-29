module Builders
  module TemplatedBuilderMethods
    
  protected
    def li_generic_field(fieldname, field, options = {})
      return field if @bypass_for_block
      
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
          li(
            li_label('') + 
            field + " " + li_label(label_text, "#{@object_name}_#{fieldname}", true) 
          )
        else
          li(
            li_label(label_text, "#{@object_name}_#{fieldname}") +
            field 
          ) 
        end
      else # No label
        li( field )
      end
    end
    
    def li(content, options = {})
      @template.content_tag 'li', content, options
    end
    
    def li_label(text, for_field, after = false)
      @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
    end
  end
end
