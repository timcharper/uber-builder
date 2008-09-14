require 'spec'
require "rubygems"
require 'active_support'
require "actionpack"
require "action_controller"
require "action_view"
require "ostruct"

require File.dirname(__FILE__) + "/../init.rb"
require File.dirname(__FILE__) + "/mock_model.rb"

Spec::Runner.configure do |config|
end

module CaptureStubMethods
  def capture(&block)
    yield
  end
  def concat(text, *args)
    @concat_output||=""
    @concat_output << text.to_s
  end
end
