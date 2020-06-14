class StaticPagesController < ApplicationController
  def index
    render "home"
  end

  def about
    render "about"
  end
end
