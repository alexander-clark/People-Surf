class PagesController < ApplicationController
  
  def home
    @title = "Home"
  end

  def why
    @title = "Why Tutor Surf?"
  end

  def faq
    @title = "FAQ"
  end
end
