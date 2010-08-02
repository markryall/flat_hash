require File.dirname(__FILE__)+'/vcs_spec'

require 'flat_hash/hg'

describe FlatHash::Hg do
  it_should_behave_like "a vcs"

  def vcs_class
    FlatHash::Git
  end
end