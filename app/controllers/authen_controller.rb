class AuthenController < ApplicationController

	layout "application"
	skip_before_filter :logged, :only => [ :login ]

	def login
		p = params[:post]
		@auth = Auth.user
		@auth.attempt(p[:username],p[:password])	
		if @auth.logged
			redirect_to home_path()
		else
			flash[:error] = "username/password not pass"
			redirect_to index_path()	
			#render text:"no"
		end
	
	end

	def logout
		@auth = Auth.user
		@auth.logout
		flash[:notice] = "You have successfully logged out."
		redirect_to index_path()	
	end
end
