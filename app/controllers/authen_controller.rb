class AuthenController < ApplicationController

	layout "application"
	skip_before_filter :logged, :only => [ :login , :signup , :signupdata]
	before_filter :guest , :only => [ :login , :signup , :signupdata]
	before_filter :validate , :only => [ :signupdata]


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


	def signup
	end

	def validate
		if params[:post][:username]==""
			flash[:error] = "Please enter e-mail"
				redirect_to signup_path()
		elsif params[:post][:password]==""
			flash[:error] = "Please enter password"
				redirect_to signup_path()
		
		elsif params[:post][:repassword]==""
			flash[:error] = "Please enter re password"
				redirect_to signup_path()
		elsif  params[:post][:agree] == "1"
			if params[:post][:password]!=params[:post][:repassword]
				flash[:error] = "You have failed two passwords not same"
				redirect_to signup_path()
			
			elsif params[:post][:password]=/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
				flash[:error] = "Invalid email"
				redirect_to signup_path()
			end

	
		else
			flash[:error] = "You have failed singup #2"
			redirect_to signup_path()
		end
	end

	def signupdata
		
		
			#render text: params[:post].inspect
			user_new = User.new
			user_new[:email]=params[:post][:username]
			user_new[:pass]=params[:post][:password]
			
			if user_new.save
				flash[:notice] = "You have successfully sigup."
				redirect_to index_path()
			else
				flash[:error] = "You have failed insert database"
				redirect_to signup_path()
			end

		

	end
end
