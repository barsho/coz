class StaticPagesController < ApplicationController
  before_filter :signed_in_user, only: [:home]

  def splash

  end
  
  def home
    
  end
  
end
