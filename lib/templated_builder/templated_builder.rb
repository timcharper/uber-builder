module Builders
  class TemplatedBuilder < ActionView::Helpers::FormBuilder
    include Builders::TabularBuilderMethods
  end
end