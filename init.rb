require "templated_builder/templated_builder_methods.rb"
require "templated_builder/templated_builder_methods_li.rb"
require "templated_builder/templated_builder_methods_table.rb"
require "templated_builder/static_templated_builder.rb"
require "templated_builder/templated_builder.rb"

%w[lib/bonus_form_helpers lib/specialized_helpers].each{|dir|
  Dir[File.join(File.dirname(__FILE__), dir, "*.rb")].each{|file|
    require file
  }
}

UberBuilder = Builders::TemplatedBuilder
StaticUberBuilder = Builders::TemplatedBuilder