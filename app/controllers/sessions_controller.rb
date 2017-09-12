
class SessionsController < ApplicationController
  
  def reset
    session[:access_token] = nil
    redirect_to :back
  end
  
  def redirect
    session[:access_token] = params[:access_token]
    p "#{params}"
    p "#{session[:access_token]}"
    head :ok and return
  end
end
