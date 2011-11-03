# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  type               :integer
#  active             :boolean
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe User do

  before :each do
    @attr = {
      :email => "user@example.com",
      :password => "password",
      :password_confirmation => "password",  
    }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require an e-mail" do
    no_email_user = User.new(@attr.merge(:email => "" ))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid e-mail addresses" do
    addresses = %w[test@example.com first.last@example.co.uk name+tag@site.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid e-mail addresses" do
    addresses = %w[user@site,com user_at_site.com user@example.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate e-mail addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject upcased duplicate e-mail" do
    User.create!(@attr)
    upcased_email = @attr[:email].upcase
    User.new(@attr.merge(:email => upcased_email)).should_not be_valid
  end

  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "parseword")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      User.new(@attr.merge(
        :password => short,
        :password_confirmation => short)
      ).
        should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
        should_not be_valid
    end
  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
        
      end
    end
  end
  
  describe "authenticate method" do
    it "should return nil on email/password mismatch" do
      User.authenticate(@attr[:email], "wrongpass").should be_nil
    end
    
    it "should return nil for an e-mail address with no user" do
      nonexistent_email = "nonexistent.user@example.com"
      User.authenticate(nonexistent_email, @attr[:password])
    end
    
    it "should return the user on email/password match" do
      User.authenticate(@attr[:email], @attr[:password]).should == @user
      
    end
  end
end
