class StaticPagesController < ApplicationController
  def home
  	 @micropost = current_user.microposts.build if signed_in? # init this for new post on home pages
  	 @feed_items = current_user.feed.paginate(page: params[:page]) if signed_in? # get it form mode to show in hoame page
  end

  def help
  end

  def about
  end

  def contact
  end
  	
end
