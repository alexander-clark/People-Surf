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
end
