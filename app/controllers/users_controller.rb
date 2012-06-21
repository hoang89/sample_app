class UsersController < ApplicationController
	def index
		
	end
	def show
		@user = User.find(params[:id])	
	end
  	def new
  		@user = User.new
  	end
  	def create
  		@user = User.new(params[:user])
  		if @user.save
  			# Handle success messaage
  			flash[:success] = "Successfully created user"
  			redirect_to @user
  		else
  			render 'new'
  		end
  	end
end
