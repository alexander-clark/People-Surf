require 'spec_helper'

describe SubjectsController do
  render_views
  
  describe "GET 'show'" do
    
    before(:each) do
      @subject = FactoryGirl.create(:subject)
    end
    
    it "should be successful" do
      get :show, :id => @subject 
      response.should be_success
    end
    
    it "should have the right title" do
      get :show, :id => @subject
      response.should have_selector("title", :content => @subject.name)
    end
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector(:title, :content => "New subject")
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @attr = {:name => "Maths", :description => "Mathematics", :parent_id => ""}
    end
    
    describe "failure" do
      
      it "should not create a new subject" do
        expect {
          post :create, :subject => @attr.merge(:name => "")
        }.to_not change(Subject, :count)
      end
      
      it "should have the right title" do
        post :create, :subject => @attr.merge(:name => "")
        response.should have_selector("title", :content => "New subject")
      end
      
      it "should render the new subject page" do
        post :create, :subject => @attr.merge(:name => "")
        response.should render_template('new')
      end
    end
    
    describe "success" do
      
      it "should be successful" do
        post :create, :subject => @attr
        response.should be_success
      end
    
      it "should create a subject" do
        expect {
          post :create, :subject => @attr
        }.to change(Subject, :count).by(1)
      end
      
      it "should have the right title" do
        post :create, :subject => @attr
        response.should have_selector("title", :content => "All Subjects")
      end
      
      it "should have a flash message" do
        post :create, :subject => @attr
        flash[:success].should =~ /created/ 
      end
      
      it "should redirect to the subjects index page" do
        post :create, :subject => @attr
        response.should render_template('index')
      end
    end
    
    describe "nested subjects" do
    
      it "should create nested subjects" do
        post :create, :subject => @attr
        post :create, :subject => {:name => "Calc", :description => "Calculus",
                                   :parent_id => 1}
        get :show, :id => 1
        response.should have_selector("li", :content => "Calc")
      end
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @subject = FactoryGirl.create(:subject)
    end
    
    it "should be successful" do
      get :edit, :id => @subject 
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @subject
      response.should have_selector("title", :content => "Edit subject")
    end    
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      @subject = FactoryGirl.create(:subject)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = {:name => "", :description => "", :parent_id => ""}
      end
      
      it "should have the right title" do
        put :update, :id => @subject, :subject => @attr
        response.should have_selector("title", :content => "Edit subject")
      end
      
      it "should render the edit layout" do
        put :update, :id => @subject, :subject => @attr
        response.should render_template('edit')
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {:name => "Math", :description => "", :parent_id => ""}
      end
      
      it "should change the subject's attributes" do
        put :update, :id => @subject, :subject => @attr
        @subject.reload
        @subject.name.should eq(@attr[:name])
        @subject.description.should == @attr[:description]
      end
      
      it "should redirect to the index page" do
        put :update, :id => @subject, :subject => @attr
        response.should redirect_to(@subject)
      end
      
      it "should display a success message" do
        put :update, :id => @subject, :subject => @attr
        flash[:success].should =~ /updated/ 
      end
    end
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  
    describe "No subjects" do
      it "should say no subjects" do
        get :index
        response.should have_selector("p", :content => "no subjects listed")
      end
    end
  
    describe "Subject present" do
      it "should display the subject" do
        FactoryGirl.create(:subject)
        get :index
        response.should have_selector("li", :content => "Maths")
      end
    end
  end
  
  describe "DELETE 'destroy" do
    
    before(:each) do
      @subject = FactoryGirl.create(:subject)
    end
    
    it "should delete the subject" do
      expect {
        delete :destroy, :id => @subject 
      }.to change(Subject, :count).by(-1)
    end
    
    describe "nested subjects" do
      it "should remove deleted children" do
        post :create, :subject => {:name => "Calc", :description => "Calculus",
                                   :parent_id => 1}
        delete :destroy, :id => 2
        get :show, :id => 1
        response.should_not have_selector("li", :content => "Calc")
      end
    end
  end
end
