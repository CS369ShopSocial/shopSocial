class ClosetsController < ApplicationController
  def create
    @closet = current_user.closets.build(:article_id => params[:article_id])
    if @closet.save
      flash[:notice] = "This item has been added to your closet!"
      redirect_to current_user
    else
      flash[:error] = "Unable add item to closet."
      redirect_to root_url
    end 
  end 

  def destroy

    @closet = Closet.find(params[:id])
    @closet.destroy
    flash[:notice] = "Item removed from closet!"
    redirect_to current_user
  end 
end
