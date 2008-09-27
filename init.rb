def require_whole_directory(dir)
  Dir[File.join(File.dirname(__FILE__), dir, "*.rb")].each{|file|
    require file
  }
end

require_whole_directory("lib/extensions")
require_whole_directory("lib/bonus_form_helpers")

for include_file in %w[layouts/p layouts/div layouts/ul layouts/table templated_methods templated_builder static_builder]
  require File.join(File.dirname(__FILE__), "lib", "#{include_file}.rb")
end

require_whole_directory("lib/3rd_party_helpers")

# set the default form builder to UberBuilder
ActionView::Base.default_form_builder = UberBuilder::TemplatedBuilder
ActionView::Base::CompiledTemplates::StaticBuilder = UberBuilder::StaticBuilder # for convienent access
