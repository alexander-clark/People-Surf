require 'spec_helper'

describe "Subjects" do
  
  describe "new" do
    
    describe "failure" do
    
      it "should not allow empty names" do
      
        expect {        
          get "subjects/new"
          fill_in :name,        :with => ""
          fill_in :description, :with => ""
          click_button
          response.should render_template('subjects/new')
          response.should have_selector("div#error_explanation")
        }.not_to change(Subject, :count)
      end
    end
  
    describe "success" do
    
      it "should create a subject" do
        expect {        
          get "subjects/new"
          fill_in :name,        :with => "Foobology"
          fill_in :description, :with => "A made-up subject"
          click_button
          response.should render_template('subjects')
          response.should have_selector("div.flash.success",
                                        :content => "Subject created")
        }.to change(Subject, :count).by(1)
      end
    end
  end
end