module UberBuilder
  module Layouts
    class Div < P
      def field(field_name, field_content, label_text, options = {})
        return li(field_content) if label_text.blank?
        
        div(
          label(label_text, "#{@object_name}_#{field_name}") + "<br />\n" + field_content,
          options[:outer] || {}
        ) + "\n"
      end
    
    protected
      def div(content, options = {})
        @template.content_tag 'div', content, options
      end
    
      def label(text, for_field, after = false)
        @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
      end
    end
  end
end
