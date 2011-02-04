require File.dirname(__FILE__)+'/spec_helper'
require 'vcs_spec_shared'

require 'flat_hash/git'

describe FlatHash::Hg do
  it_should_behave_like "a vcs wrapper"

  def vcs_class
    FlatHash::Git
  end

  it 'should handle checking for nonexistant paths' do
    in_vcs_working_directory do |vcs|
      write 'some content', 'a', 'b', 'c', 'file1'
      vcs.addremovecommit 'added file1 and file2'

      changeset = vcs.changesets.first
      vcs.contains?(changeset, 'file1').should be_false
      vcs.contains?(changeset, 'b/c/file1').should be_false
      vcs.contains?(changeset, 'a/b/c/file1').should be_true
    end
  end
end