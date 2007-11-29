module Builders
  module TemplatedBuilderMethods
    
    def calendar_date_select(field, options = {})
      field = field.to_s
      tabular_options = extract_tabular_options(field, options)
      
      generic_field(field, super, tabular_options)
    end
  end
  
  class StaticBuilder
    def calendar_date_select(method, options={})
      time_field = options.delete(:time) ? true : false
      options[:format]||="%B %d, %Y"+ (time_field ? " %I:%M %p" : '')
      
      value = object.send(method).strftime(options[:format]) rescue ""
      
    end
  end
end
