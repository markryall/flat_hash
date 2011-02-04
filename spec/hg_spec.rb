require File.dirname(__FILE__)+'/spec_helper'
require 'vcs_spec_shared'

require 'flat_hash/hg'

describe FlatHash::Hg do
  it_should_behave_like "a vcs wrapper"

  def vcs_class
    FlatHash::Hg
  end
end