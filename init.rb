def require_whole_directory(dir)
  Dir[File.join(File.dirname(__FILE__), dir, "*.rb")].each{|file|
    require file
  }
end

require_whole_directory("lib/overrides")
require_whole_directory("lib/bonus_form_helpers")

for include_file in %w[../static_builder_base templated_builder_methods templated_builder_methods_li templated_builder_methods_table templated_builder static_builder]
  require File.join(File.dirname(__FILE__), "lib/templated_builder", "#{include_file}.rb")
end

require_whole_directory("lib/3rd_party_helpers")

# set the default form builder to UberBuilder
ActionView::Base.default_form_builder = Builders::TemplatedBuilder
ActionView::Base::CompiledTemplates::StaticBuilder = Builders::StaticBuilder # for convienent access
