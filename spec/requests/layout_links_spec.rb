require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a FAQ page at '/faq'" do
    get '/faq'
    response.should have_selector('title', :content => "FAQ")
  end
  
  it "should have a Why Tutor Surf page at '/why'" do
    get '/why'
    response.should have_selector('title', :content => "Why Tutor Surf?")
  end
  
  it "should have a Signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end
  
  describe "when signed in" do
  
    describe "admin" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        @user.toggle!(:admin)
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end
      
      it "should have a users link" do
        visit root_path
        response.should have_selector("a", :href => users_path,
                                           :content => "Users")
      end
    end
    
    describe "student" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        visit signin_path
        fill_in :email,    :with => @user.email
        fill_in :password, :with => @user.password
        click_button
      end

      it "should have a signout link" do
        visit root_path
        response.should have_selector("a", :href => signout_path,
                                           :content => "Sign out")
      end

      it "should have a profile link" do
        visit root_path
        response.should have_selector("a", :href => user_path(@user),
                                           :content => "Profile")
      end

      it "should have a settings link" do
        visit root_path
        response.should have_selector("a", :href => "/users/#{@user.id}/edit",
                                           :content => "Settings")
      end

      it "should have a subjects link" do
        visit root_path
        response.should have_selector("a", :href => subjects_path,
                                           :content => "Subjects")
      end
      
      it "should have a users link" do
        visit root_path
        response.should have_selector("a", :href => users_path,
                                           :content => "Tutors")
      end
    end
  end
  
  describe "tutor" do
      
    before(:each) do
      @user = FactoryGirl.create(:user, :type => 2)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should have a users link" do
      visit root_path
      response.should have_selector("a", :href => users_path,
                                         :content => "Students")
    end
  end
end
