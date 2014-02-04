class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index , :createdomain]
	skip_before_filter :verify_authenticity_token, :only => [:createdomain]
	
	def index
	end

	def choose
	end

	def createdomain
		sendMessageValidationDomain = "domain:"+"'"+isDomainName(params[:domain])+"'"
		sendMessageValidationPort = "port:"+"'"+isPort(params[:port])+"'"
		sendMessageValidationPassword = "password:"+"'"+"Accept"+"'"

		render text: "{"+sendMessageValidationDomain+","+sendMessageValidationPort+","+sendMessageValidationPassword+"}"
	end





	def isDomainName(addr)
		if addr.length >= 5
			return 'Accept'
		end
		return 'Domain: Lenght more than 5.'
	end

	def isPort(port)
		num = Integer(port) rescue -1
		if num >= 0
			return 'Accept'
		end
		return 'Port: Invalid port number'
	end
	private :isDomainName , :isPort
end
