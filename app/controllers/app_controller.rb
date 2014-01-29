class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index ]
	
	def index
	end

	def home
	end
end
