module UberBuilder
  module Layouts
    class Div < P
      def field(field_name, field_content, label_text, options = {})
        return div(field_content) if label_text.blank?
        
        div(
          label(label_text, "#{sanitized_object_name}_#{field_name}") + "<br />\n".html_safe + field_content,
          options[:outer] || {}
        ) + "\n"
      end
    
    protected
      def div(content, options = {})
        @template.content_tag 'div', content, options
      end
    end
  end
end
