module ActionView
  module Helpers
    module FormHelper
      def radio_button_list(object, method, choices=[], options={})
        output = ""
        choices.each{ |choice|
          if choice.is_a? Array
            label=choice[1]
            value=choice[0]
          else
            label=choice.to_s
            value=choice.to_s
          end
          
          output << radio_button(object, method, value) + " <label>#{label}</label> "
        }
        
        output
      end  
    end
    
    class FormBuilder
      def radio_button_list(method, choices, options = {})
        @template.radio_button_list(@object_name, method, choices, options.merge(:object => @object))
      end
      self.field_helpers << :currency_field
    end
  end
end
