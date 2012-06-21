module SessionsHelper
	def sign_in(user)
	# add cookies for 20 years for this user by use  permanent function 
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  	end

  	def current_user=(user)
  		@current_user = user
  	end

  	def current_user
  		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
  	end

  	def signed_in?
  		!current_user.nil?
  	end

    def sign_out
      self.current_user = nil;
      cookies.delete(:remember_token)
    end
end
