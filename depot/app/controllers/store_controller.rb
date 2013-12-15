class StoreController < ApplicationController
  def increment_counter
    if session[:counter].nil?
      session[:counter] = 0
    end
    session[:counter] += 1
  end
  def index
    @products = Product.all
    @counter = increment_counter
    @message = "You've visited this page #{@counter} times" if @counter > 5
  end
end
