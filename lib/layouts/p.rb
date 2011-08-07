module UberBuilder
  module Layouts
    class P
      attr_reader :object_name
      def initialize(template, object_name, builder)
        @template = template
        @builder = builder
        @object_name = object_name
      end
      
      def section(content, html_options = {})
        content
      end
      
      def field(field_name, field_content, label_text, options = {})
        return p(field_content) if label_text.blank?
        
        p(
          label(label_text, "#{sanitized_object_name}_#{field_name}") + "<br />\n".html_safe + field_content,
          options[:outer]
        ) + "\n"
      end
    
    protected
      def p(content, options = {})
        @template.content_tag 'p', content, options
      end
    
      def label(text, for_field, after = false)
        (@template.content_tag('label', "#{text}", :for => for_field) + (after ? '' : ':'))
      end

      def sanitized_object_name
        @template.send(:sanitize_to_id, @object_name)
      end
    end
  end
end
