require File.dirname(__FILE__)+'/spec_helper'

describe FlatHash::Directory do
  before do
    @hash = {'key1'=>'value1', 'key2'=>'value2'}
    @key = 'somekey'
  end

  it "should initially contain no entries" do
    in_temp_directory do
      with_directory do |directory|
        directory.entries.should == []
      end
    end
  end

  it "should enumerate keys" do
    in_temp_directory do
      with_directory do |directory|
        directory[@key] = @hash
        directory.entries.should == [@hash]
      end
    end
  end

  it "should add id to hash" do
    in_temp_directory do
      with_directory do |directory|
        directory[@key] = @hash
      end
      with_directory do |directory|
        directory[@key].id.should == @key
      end
    end
  end

  it "should expose indexers" do
    in_temp_directory do
      with_directory do |directory|
        directory[@key] = @hash
      end
      with_directory do |directory|
        directory[@key].should == @hash
      end
    end
  end

  it "should allow entries to be appended" do
    in_temp_directory do
      with_directory do |directory|
        directory << FlatHash::Entry.new(@key, @hash)
      end
      with_directory do |directory|
        directory[@key].should == @hash
      end
    end
  end
  
  it "should allow entries to be destroyed" do
    in_temp_directory do
      with_directory do |directory|
        directory.entries.should == []
        directory << FlatHash::Entry.new(@key, @hash)
        directory[@key].should == @hash
        directory.destroy(@key)
        directory.entries.should == []
      end
    end
  end
end