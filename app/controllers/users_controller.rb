class UserController < ApplicationController
	def index
		
	end
	def show
		@user = User.find(param[:id])	
	end
  	def new
  	end
end
