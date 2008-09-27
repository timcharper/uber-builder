module UberBuilder
  module Layouts
    class Ul < P
      def section(content, html_options = {})
        @template.content_tag(:ul, content, {:class => "form"}.merge(html_options))
      end
      
      def field(field_name, field_content, label_text, options = {})
        return li(field_content) if label_text.blank?
        
        if options[:label] == :after
          li(
            label('') + field_content + " " + li_label(label_text, "#{@object_name}_#{field_name}", true),
            options[:outer]
          )
        else
          li(
            label(label_text, "#{@object_name}_#{field_name}") + field_content,
            options[:outer]
          ) 
        end
      end
    
    protected
      def li(content, options = {})
        @template.content_tag 'li', content, options
      end
    end
  end
end
