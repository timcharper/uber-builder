require "test/unit"
require "rubygems"
require 'active_support'
require "actionpack"
require "action_controller"
require "action_view"

def dbg; require 'ruby-debug'; debugger; end
require File.dirname(__FILE__) + "/../init.rb"
require File.dirname(__FILE__) + "/mock_model.rb"
