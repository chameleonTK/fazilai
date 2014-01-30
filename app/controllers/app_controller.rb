class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index ]
	
	def index
	end

	def choose
	end
end
