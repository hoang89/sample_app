class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create , :destroy]
    before_filter :correct_user,   only: :destroy
  def create
  	@micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

 

  def index
  end
 private

  def correct_user
    # thay vi su dung Micropost.find(params[:id]) chung ta su dung 
    # current_user.micropost.find_by_id(params[:id]) de tranh gay loi xoa tai nguyen nguoi khac
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
