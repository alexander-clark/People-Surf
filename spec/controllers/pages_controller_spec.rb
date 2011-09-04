require 'spec_helper'

describe PagesController do
  render_views
  
  before :each do
    @base_title = "Tutor Surf"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                        :content => @base_title + " | Home")
    end
  end

  describe "GET 'why'" do
    it "should be successful" do
      get 'why'
      response.should be_success
    end

    it "should have the right title" do
      get 'why'
      response.should have_selector("title",
                        :content => @base_title + " | Why Tutor Surf?")
    end
  end

  describe "GET 'faq'" do
    it "should be successful" do
      get 'faq'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'faq'
      response.should have_selector("title",
                        :content => @base_title + " | FAQ")
    end
  end
end
