# == Schema Information
#
# Table name: subjects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  ancestry    :string(255)
#

require 'spec_helper'

describe Subject do
  before(:each) do
    @attr = {
      :name => "Maths",
      :description => "Mathematics",
      :parent_id => ""
    }
  end
  
  describe "create" do
    it "should create a new subject given valid attributes" do
      Subject.create(@attr).should be_valid
    end
    
    it "should reject empty subject names" do
      Subject.create(@attr.merge(:name => "")).should_not be_valid
    end
    
    it "should reject duplicate subject names" do
      Subject.create(@attr)
      Subject.create(@attr).should_not be_valid
    end
    
    it "should reject duplicate upcased subject names" do
      Subject.create(@attr)
      Subject.create(@attr.merge(:name => "MATHS")).should_not be_valid
    end
  end
  
  it "should respond to parent" do
    subject = Subject.create(@attr)
    subject.should respond_to(:parent)
  end
  
  it "should assign valid parents" do
    maths = Subject.create(@attr)
    subject = Subject.create(@attr.merge(:name => "Algebra",
                                         :parent_id => maths.id))
    subject.parent.should == maths
  end
end
