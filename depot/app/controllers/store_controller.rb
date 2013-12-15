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
  end
end
