class DynamicPagesController < ApplicationController
  before_action :signed_in_user, only: [:closet]
  def closet
    @dynamic_pages = current_user.articles.paginate(:page => params[:page]) 
  end 

  def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_url, notice: "Please sign in."
      end 
  end
end
