module UberBuilder
  module Layouts
    class P
      def initialize(template, object_name, builder)
        @template = template
        @builder = builder
        @object_name = object_name
      end
      
      def section(content, html_options = {})
        content
      end
      
      def field(field_name, field_content, label_text, options = {})
        return li(field_content) if label_text.blank?
        
        p(
          label(label_text, "#{@object_name}_#{field_name}") + "<br />\n" +
          field_content
        ) + "\n"
      end
    
    protected
      def p(content, options = {})
        @template.content_tag 'p', content, options
      end
    
      def label(text, for_field, after = false)
        @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
      end
    end
  end
end
