class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :logged

	private
	def logged
		@auth = Auth.user
		if @auth.guest
			#render text: @auth.guest
			redirect_to index_path
		end
	end

end
