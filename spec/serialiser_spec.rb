require File.dirname(__FILE__)+'/spec_helper'

describe FlatHash::Serialiser, '#read' do
  before do
    @io = StringIO.new
    @serialiser = FlatHash::Serialiser.new(@io)    
  end

  def read string
    @io.string = string
    @serialiser.read
  end

  it "should read an empty hash when stream is empty" do
    read('').should == {}
  end

  it "should read a single line and treat it as a key" do
    read('key').should == {'key' => ''}
  end

  it "should read a double line and treat it as a key and value" do
    read(<<EOF).should == {'key' => 'value'}
key
value
EOF
  end

  it "should read multiple key value pairs delimited by <----->" do
    read(<<EOF).should == {'key1' => 'value1', 'key2' => 'value2'}
key1
value1
<----->
key2
value2
EOF
  end

  it "should read multiple line values" do
    read(<<EOF).should == {'key1' => "value1line1\nvalue1line2", 'key2' => "value2line1\nvalue2line2"}
key1
value1line1
value1line2
<----->
key2
value2line1
value2line2
EOF
  end
end

describe FlatHash::Serialiser, '#write' do
  before do
    @io = StringIO.new
    @serialiser = FlatHash::Serialiser.new(@io)    
  end
  
  def write hash
    @serialiser.write(hash)
    @io.flush
    @io.string
  end

  it 'should output empty string ' do
    write({}).should == ''
  end

  it 'should write single key' do
    write({'key' => 'value'}).should == <<EOF
key
value
EOF
  end
  
  it 'should write multiple keys delimited by <-----> in order by key' do
    write({'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3'}).should == <<EOF
key1
value1
<----->
key2
value2
<----->
key3
value3
EOF
  end
end