require File.dirname(__FILE__)+'/spec_helper'

describe FlatHash::Repository do
  it "should raise exception when no vcs repository is detected" do
    in_temp_directory do
      lambda { with_repository }.should raise_exception(RuntimeError, 'could not determine repository type')
    end
  end
end

shared_examples_for "a repository" do
  it "should have an initially empty history" do
    in_vcs_repository(vcs_class.new) do |vcs|
      with_repository do |repository|
        repository.history.should == []
      end
    end
  end

  it "should detect repository type" do
    in_vcs_repository(vcs_class.new) do |vcs|
      with_repository do |repository|
        repository.type.should == vcs_class.new.name
      end
    end
  end

  it 'should enumerate the revisions' do
    in_vcs_repository(vcs_class.new) do |vcs|
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

describe FlatHash::Repository, 'git' do
  it_should_behave_like "a repository"

  def vcs_class
    Git
  end
end

describe FlatHash::Repository, 'hg' do
  it_should_behave_like "a repository"

  def vcs_class
    Hg
  end
end