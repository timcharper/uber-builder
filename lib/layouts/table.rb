module UberBuilder
  module Layouts
    class Table < P
      def section(content, html_options = {})
        @template.content_tag(:table, content, {:class => "form"}.merge(html_options))
      end
      
      def field(field_name, field_content, label_text, options = {})
        case
        when label_text.blank?
          tr(
            td("&nbsp;", :class => :label) + td(field_content),
            options[:outer]
          ) 
        when options[:label] == :after
          tr(td('') + td(field_content + " " + label(label_text, "#{@object_name}_#{field_name}", true)), options[:outer] )
        else
          tr(
            td(label(label_text, "#{@object_name}_#{field_name}"), :class => :label) + td(field_content),
            options[:outer]
          ) 
        end
      end
      
    protected
      def tr(content, options = {})
        @template.content_tag 'tr', content, options
      end

      def td(content, options = {})
        @template.content_tag 'td', content, options
      end
    end
  end
end
