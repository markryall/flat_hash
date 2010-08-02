require File.dirname(__FILE__)+'/spec_helper'

require 'flat_hash/hg'

describe FlatHash::Hg do
  def vcs_class
    FlatHash::Git
  end

  it "should initially have no changesets" do
    in_vcs_working_directory do |vcs|
      vcs.changesets.size.should == 0
    end
  end

  it "should retrieve single changeset" do
    in_vcs_working_directory do |vcs|
      write 'file1', 'some content'
      vcs.addremovecommit 'first commit'
      vcs.changesets.size.should == 1
    end
  end

  it "should retrieve details of each changeset" do
    in_vcs_working_directory do |vcs|
      write 'file1', 'some content'
      write 'file2', 'some different content'
      vcs.addremovecommit 'added file1 and file2'

      write 'file1', 'some new content'
      delete 'file2'
      vcs.addremovecommit 'modified file1 and removed file2'

      second, first = vcs.changesets

      vcs.changeset(first).instance_eval do
        id.should == first
        additions.should == ['file1', 'file2']
        # deletions.should == []
        # modifications.should == []
        description.should == 'added file1 and file2'
      end
      vcs.content_at('file1',first).should == 'some content'
      vcs.content_at('file2',first).should == 'some different content'

      vcs.changeset(second).instance_eval do
        id.should == second
        # additions.should == []
        # deletions.should == ['file2']
        # modifications.should == ['file1']
        description.should == 'modified file1 and removed file2'
      end
      vcs.content_at('file1',second).should == 'some new content'
    end
  end
end