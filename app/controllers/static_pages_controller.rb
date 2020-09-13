class StaticPagesController < ApplicationController
  def index
    @regions = Query.where(scope: 'region')
    @counties = Query.where(scope: 'county')
    render "home"
  end

  def about
    render "about"
  end

  def submit
    render "submit"
  end
end
