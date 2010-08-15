require File.dirname(__FILE__)+'/spec_helper'

require 'flat_hash/serialiser'

describe FlatHash::Serialiser, '#yaml' do
  before do
    @serialiser = FlatHash::Serialiser.new   
  end

  def read string
    @serialiser.read StringIO.new(string)
  end

  it "should detect and deserialise yaml persisted hash" do
    hash = {'key1' => 'value1', 'key2' => 'value2'}
    read(hash.to_yaml).should == hash
  end

  it "should detect and deserialise yaml persisted open struct" do
    ostruct = OpenStruct.new
    ostruct.keya = 'valuea'
    ostruct.keyb = 'valueb'
    read(ostruct.to_yaml).should == {'keya' => 'valuea', 'keyb' => 'valueb'}
  end
end