require 'ostruct'

class MutedOpenStruct < OpenStruct
  attr_accessor :id, :type
  protected :id, :type
end

class MockModel < MutedOpenStruct
  cattr_accessor :columns_hash
  self.columns_hash = {
    "balance" => MutedOpenStruct.new(:type => :decimal, :scale => 2),
    "int_balance" => MutedOpenStruct.new(:type => :integer),
    "age" => MutedOpenStruct.new(:type => :integer),
    "meters" => MutedOpenStruct.new(:type => :float),
    "long" => MutedOpenStruct.new(:type => :decimal, :precision => 10, :scale => 3),
    "lat" => MutedOpenStruct.new(:type => :decimal, :precision => 10, :scale => 3)
  }
  
end
