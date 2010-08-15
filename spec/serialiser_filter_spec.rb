require File.dirname(__FILE__)+'/spec_helper'

require 'flat_hash/serialiser'

describe FlatHash::Serialiser, 'with filter' do
  it "should call filter read method on read" do
    io = stub(:io)
    filter = stub(:filter)
    sio = StringIO.new("key\nvalue")
    serialiser = FlatHash::Serialiser.new(io, filter)
    filter.should_receive(:read).with(io).and_return(sio)
    serialiser.read.should == {'key' => 'value'}
  end

  it "should call filter write method on write" do
    io = stub(:io)
    sio = StringIO.new
    filter = stub(:filter)

    StringIO.stub!(:new).and_return(sio)
    serialiser = FlatHash::Serialiser.new(io, filter)
    filter.should_receive(:write).with("key\nvalue\n", io)

    serialiser.write({'key' => 'value'})
  end
end