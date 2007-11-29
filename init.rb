for include_file in %w[../static_builder templated_builder_methods templated_builder_methods_li templated_builder_methods_table templated_builder static_templated_builder]
  require File.join(File.dirname(__FILE__), "lib/templated_builder", "#{include_file}.rb")
end

%w[lib/bonus_form_helpers lib/specialized_helpers].each{|dir|
  Dir[File.join(File.dirname(__FILE__), dir, "*.rb")].each{|file|
    require file
  }
}

TemplatedBuilder = Builders::TemplatedBuilder
StaticBuilder = Builders::StaticTemplatedBuilder

# set the default form builder to UberBuilder
ActionView::Base.default_form_builder = Builders::TemplatedBuilder