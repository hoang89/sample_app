class UsersController < ApplicationController
	 before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	 before_filter :correct_user,   only: [:edit, :update]
	 before_filter :admin_user,     only: :destroy
	 before_filter :delete_himself, only: :destroy
	def index
		
		@users = User.paginate(page: params[:page], per_page: 30)
	end # end of index

	def show
		@user = User.find(params[:id])	
	end # end of show

	def new
		@user = User.new
	end # end of new

	def create
		@user = User.new(params[:user])
		if @user.save
			# Handle success messaage
     	 sign_in @user
		 flash[:success] = "Successfully created user"
		 redirect_to @user
		else
			render 'new'
		end
	end

  def edit
     @user = User.find_by_id(params[:id])
  end

  def update
  	@user = User.find_by_id(params[:id])
  	if @user.update_attributes(params[:user])
      # Handle a successful update.
      sign_in @user
	  flash[:success] = "Successfully updated user"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
  	 User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

    def signed_in_user	
      unless signed_in?  
      store_location 
	  redirect_to signin_path, notice: "Please sign in."
	  end 
    end

  	def correct_user
  		@user = User.find(params[:id])
      	redirect_to(root_path) unless current_user?(@user)
  	end

  	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def delete_himself
    	@del_user = User.find(params[:id])
    	redirect_to(root_path) if  @del_user.admin?
    end
end
