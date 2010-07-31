require File.dirname(__FILE__)+'/spec_helper'

describe FlatHash::Repository do
  it "should have an initial empty history" do
    with_repository do |repository|
      repository.history.should == []
    end
  end
end

describe FlatHash::Repository, 'git' do
  it "should detect git repository" do
    in_vcs_repository(Git.new) do |vcs|
      with_repository do |repository|
        repository.type.should == :git
      end
    end
  end

  it 'should enumerate the revisions' do
    in_vcs_repository(Git.new) do |vcs|
      with_repository do |repository|
        repository['entry1'] = {'key' => 'value'}
        vcs.addremovecommit 'first commit'
        repository.history.size.should == 1
      end
    end
  end

  it 'should detect additions'
  it 'should detect deletions'
  it 'should detect modifications'  
end

describe FlatHash::Repository, 'hg' do
  it "should detect hg repository" do
    in_vcs_repository(Hg.new) do |vcs|
      with_repository do |repository|
        repository.type.should == :hg
      end
    end
  end

  it 'should enumerate the revisions' do
    in_vcs_repository(Hg.new) do |vcs|
      with_repository do |repository|
        repository['key'] = {'key1' => 'value1'}
        vcs.addremovecommit 'first commit'
        repository.history.size.should == 1
      end
    end
  end

  it 'should detect additions'
  it 'should detect deletions'
  it 'should detect modifications'
end