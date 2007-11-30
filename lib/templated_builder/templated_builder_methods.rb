module Builders
  module TemplatedBuilderMethods
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::CaptureHelper
    
    def initialize(*args)
      super
      
      @builder_mode = nil
      @bypass_for_block = false
    end
    
    ( ActionView::Helpers::FormBuilder.field_helpers - %w(check_box radio_button radio_button_list hidden_field) + %w(time_select)).each do |selector| 
      class_eval <<-END_SRC, __FILE__, __LINE__ 
        def #{selector}(field, options = {})
          field = field.to_s
          tabular_options = extract_tabular_options(field, options)
          generic_field(field, super, tabular_options )
        end 
      END_SRC
    end
    
    def hidden_field(field, options={})
      return super
    end
    
    %w(check_box radio_button).each do |selector|
      class_eval <<-END_SRC, __FILE__, __LINE__
        def #{selector}(field, options = {})
          field = field.to_s
          tabular_options = extract_tabular_options(field, options)
          generic_field(field, super, tabular_options.merge(:label => :after))
        end
      END_SRC
    end
    
    def static(text, options = {})
      tabular_options = extract_tabular_options("", options)
      generic_field(nil, text, tabular_options)
    end
    
    def submit(text="Submit", options = {})
      generic_field(nil, @template.submit_tag(text, options))
    end
    
    def select(field, choices, options = {}, html_options = {})
      field = field.to_s
      tabular_options = extract_tabular_options(field, options)
      generic_field(field, super, tabular_options )
    end
    
    def radio_button_list(field, choices, options = {})
      field = field.to_s
      tabular_options = extract_tabular_options(field, options)
      generic_field(field, super, tabular_options )
    end
    
    def generic_field(fieldname, field, options = {})
      return field if @builder_mode.nil?
      
      self.send("#{@builder_mode}_generic_field", fieldname, field, options)
    end
    
    def table(html_options = {}, &block)
      raise "expected a block" unless block_given?
      content = with_mode("table") {capture(&block)}
      
      concat( @template.content_tag(:table, content, {:class => "form"}.merge(html_options)), block.binding )
    end
    
    def ul(html_options = {}, &block)
      raise "expected a block" unless block_given?
      content = with_mode("li") {capture(&block)}
      
      concat( @template.content_tag(:ul, content, {:class => "form"}.merge(html_options)), block.binding )
    end
    
    def manual(options = {}, &block)
      raise "manual expects a block" unless block_given?
      
      content = with_mode(nil) {capture(&block)}
      tabular_options = extract_tabular_options( "", options )
      
      concat( generic_field("", content, tabular_options), block.binding)
    end
    alias :multiple :manual
    
    # create a new instance of the builder as a different class - helpful when wanting to convert to and from static
    def to(klass)
      new_builder = klass.allocate
      self.instance_variables.each{|instance_variable|
        new_builder.instance_variable_set(instance_variable, self.instance_variable_get(instance_variable))
      }
      
      new_builder
    end
    
    def to_static
      self.to(Builders::StaticTemplatedBuilder)
    end
    
  protected
    def extract_tabular_options(field, options)
      {
        :label_text => options.delete(:label) || field.to_s.humanize,
        :required => options.delete(:required) || false,
        :prefix => options.delete(:prefix),
        :suffix => options.delete(:suffix),
        :row => options.delete(:row)
      }
    end
    
    def with_mode(mode, &block)
      last_mode, @builder_mode = @builder_mode, mode
      return_value = yield
      @builder_mode = last_mode
      return_value
    end
  end
end