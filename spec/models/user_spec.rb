require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
  it "has a signup method" do
    User.should respond_to 'new'
  end
end
