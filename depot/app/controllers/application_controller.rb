class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :time

  def time
    Time.now
  end
end
