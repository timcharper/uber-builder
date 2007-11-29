module Builders
  class StaticBuilder
    attr_accessor :object_name, :object, :options
  
    class MyHelper
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers
    end
    
    @@helper=MyHelper.new
    
    def initialize(object_name, object, template, options, proc)
      @object_name, @object, @template, @options, @proc = object_name, object, template, options, proc        
    end
    
    def select(field, choices, options = {}, html_options = {})
      value = object.send(field)
      choices.each{| label, index| 
        return label if index == value 
      }
      
      ""
    end
    
    def [](index)
      object.send(index)
    end
    
    def radio_button_list(method, choices, options = {})
      element_value=self[method]
      
      choices.each{ |choice|
        if choice.is_a? Array
          label=choice[1]
          value=choice[0]
        else
          label=choice.to_s
          value=choice.to_s
        end
        
        if element_value==value
          return label
        end
      }
      
      "-"
    end
    
    include ActionView::Helpers::AssetTagHelper
    def check_box(method, options = {})
      element_value=self[method]
   
      "<image src='/images/checkbox_#{element_value ? "on" : "off"}.gif' /> "
      
  #    MyHelper.new.check_box_tag "checkbox", :checked => self[method]?"true":"false", :readonly=>true
    end
    
    def text_field(method, options = {})
      value = self[method]
      if options[:force].to_s=="whole_dollar"
        @@helper.number_to_currency(value, :unit=>"")
      else
        value
      end
    end
    
    def text_area(method, options = {})
      value = self[method]
      
      "<pre>#{value}</pre>"
    end
    
    def object
      @object || @template.instance_variable_get("@#{@object_name}")
    end
    
    def method_missing(*args)
      value = object.send(args[1])
    end
    
  end
end
