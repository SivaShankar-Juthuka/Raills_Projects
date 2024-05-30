class HomeController < ApplicationController
  def index
  end

  def about
    @users = User.all
  end
end