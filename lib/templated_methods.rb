module UberBuilder
  module TemplatedMethods
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::CaptureHelper
    
    def initialize(*args)
      super
      
      @layout = nil
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
    
    def generic_field(fieldname, field_content, options = {})
      return field_content if @layout.nil? || @bypass_for_block
      
      field_content = options[:prefix] + field_content.to_s if options[:prefix]
      field_content = field_content.to_s + options[:suffix] if options[:suffix]
      
      label_text = options[:label_text]
      label_text = "*#{label_text}" if options[:required]
      
      @layout.field(fieldname, field_content, label_text, options)
    end
    
    def manual(options = {}, &block)
      raise "manual expects a block" unless block_given?
      
      content = with_layout(nil) {capture(&block)}
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
      self.to(UberBuilder::StaticBuilder)
    end
    
    def static?
      is_a?(UberBuilder::StaticBuilder)
    end
    
    def respond_to?(method, include_private = false)
      super || define_layout_method(method)
    end
    
    def method_missing(method, *args, &block)
      respond_to?(method) ? send(method, *args, &block) : super
    end
    
  protected
    def define_layout_method(method)
      const_name = method.to_s.classify
      return false unless UberBuilder::Layouts.const_defined?(const_name)
      
      self.class.class_eval <<-EOF
        def #{method}(html_options = {}, &block)
          raise "expected a block" unless block_given?
          layout = UberBuilder::Layouts::#{const_name}.new(@template, @object_name, self)
          content = with_layout(layout) { capture(&block) }
          concat( layout.section(content, html_options), block.binding )
        end
        
        public :#{method}
      EOF
      true
    end
    
    def extract_tabular_options(field, options)
      {
        :label_text => options.delete(:label) || field.to_s.humanize,
        :required => options.delete(:required) || false,
        :prefix => options.delete(:prefix),
        :suffix => options.delete(:suffix),
        :outer => options.delete(:outer)
      }
    end
    
    def with_layout(layout, &block)
      last_layout, @layout = @layout, layout
      return_value = yield
      @layout = last_layout
      return_value
    end
  end
end