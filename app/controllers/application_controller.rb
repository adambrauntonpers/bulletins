class ApplicationController < ActionController::Base
  #protect_from_forgery
  
  def authorise
    unless session[:teacher] != nil
      flash[:notice] = "Please login"
      redirect_to(:controller => "login", :action => "login")
    end    
  end
end
