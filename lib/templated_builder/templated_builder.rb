module Builders
  class TemplatedBuilder < ActionView::Helpers::FormBuilder
    include Builders::TemplatedBuilderMethods
  end
end