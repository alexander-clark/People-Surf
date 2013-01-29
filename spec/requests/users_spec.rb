require 'spec_helper'

describe "Users" do

  describe "signup" do
    
    describe "failure" do
      
      it "should not make a new user" do
        expect {
          visit signup_path
          fill_in "First name",   :with => "" 
          fill_in "Last name",    :with => ""
          fill_in "Username",     :with => ""  
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        }.not_to change(User, :count)
      end
    end
    
    describe "success" do
      
      it "should make a new user" do
        expect {
          visit signup_path
          choose  "user_type_1"
          fill_in "First name",   :with => "Fred"
          fill_in "Last name",    :with => "Bloggs" 
          fill_in "Username",     :with => "user"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        }.to change(User, :count).by(1)
        User.last.type.should eq(1)
      end
    end
  end

  describe "sign in/out" do
    
    describe "failure" do
      
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")  
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do
        user = FactoryGirl.create(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "admin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.toggle!(:admin)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should have delete links" do
      visit users_path
      response.should have_selector("a", :content => "delete")
    end
    
    it "should have filter links" do
      visit users_path
      response.should have_selector("a", :href => "/users?type=1",
                                         :content => "Students")
      response.should have_selector("a", :href => "/users?type=2",
                                         :content => "Tutors")
      response.should have_selector("a", :content => "All")
    end
  end
  
  describe "non-admin" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should not have delete links" do
      visit users_path
      response.should_not have_selector("a", :content => "delete")
    end
    
    it "should not have filter links" do
      visit users_path
      response.should_not have_selector("a", :href => "/users?type=1",
                                             :content => "Students")
      response.should_not have_selector("a", :href => "/users?type=2",
                                             :content => "Tutors")
      response.should_not have_selector("a", :content => "All")
    end
  end
end
