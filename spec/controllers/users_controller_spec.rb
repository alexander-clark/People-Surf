require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      
      before(:each) do
        @attr = { :email  => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should not create a user" do
        expect {
          post :create, :user => @attr
        }.to_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :type => 1, :first_name => "New", :last_name => "User",
                  :email => "user@example.com", :password => "foobar",
                  :password_confirmation => "foobar", :username => "newuser"}
      end
      
      it "should create a user" do
        expect {
          post :create, :user => @attr 
        }.to change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user))) 
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to tutorsurf/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in 
      end
    end
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = {:email => "", :password => "",
                 :password_confirmation => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit') 
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user") 
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {:type => 2, :email => "user@example.org", 
                 :password => "barbaz", :password_confirmation => "barbaz",
                 :first_name => "Sample", :last_name => "Person",
                 :username => "sample.person"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should  eq(@attr[:first_name])
        @user.last_name.should eq(@attr[:last_name])
        @user.email.should == @attr[:email] 
      end
      
      it "should not change the user's username" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.username.should_not == @attr[:username]
      end
      
      it "should not change the user's type" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.type.should_not == @attr[:type]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user)) 
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/ 
      end
    end
  end
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path) 
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "user@example.net",
                             :username => "wronguser")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path) 
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path) 
      end
    end
  end
  
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in users" do
    
      describe "admin" do
        before(:each) do
          @user = test_sign_in(FactoryGirl.create(:user))
          @user.toggle!(:admin)
          second = FactoryGirl.create(:user, :email => "another@example.com", :username => "second", :type => 2)
          third = FactoryGirl.create(:user, :email => "athird@example.com", :username => "third")

          @users = [@user, second, third]
          30.times do
            @users << FactoryGirl.create(:user, :email => FactoryGirl.generate(:email), :username => FactoryGirl.generate(:username))
          end
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
        
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "All users")
        end
      
        it "should have an element for each user" do
          get :index
          @users[0..2].each do |user|
            response.should have_selector("li", :content => user.email)
          end
        end
      
        it "should paginate users" do
          get :index
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector("a", :href => "/users?page=2",
                                             :content => "2")
          response.should have_selector("a", :href => "/users?page=2",
                                             :content => "Next")
        end
      end
      
      describe "student" do
        
        before(:each) do
          @user = test_sign_in(FactoryGirl.create(:user))
          second = FactoryGirl.create(:user, :email => "another@example.com", :username => "second", :type => 2)
          third = FactoryGirl.create(:user, :email => "athird@example.com", :username => "third")

          @users = [@user, second, third]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
        
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "All Tutors")
        end
        
        it "should only display tutors" do
          get :index
          response.should_not have_selector("li", :content => @users[2].email)
        end
      end
      
      describe "tutor" do
        
        before(:each) do
          @user = test_sign_in(FactoryGirl.create(:user, :type => 2))
          second = FactoryGirl.create(:user, :email => "another@example.com", :username => "second", :type => 2)
          third = FactoryGirl.create(:user, :email => "athird@example.com", :username => "third")
          @users = [@user, second, third]
        end
        
        it "should be successful" do
          get :index
          response.should be_success
        end
        
        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "All Students")
        end
        
        it "should only display students" do
          get :index
          response.should_not have_selector("li", :content => @users[1].email)
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        admin = FactoryGirl.create(:user, :type => 1, :email => "admin@example.com", :admin => true, :username => "admin")
        test_sign_in(admin)
      end
      
      it "should destroy the user" do
        expect {
          delete :destroy, :id => @user
        }.to change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
