class Auth
	def self.user
		if @u.nil?
			@u = Auth.new
		end
		return @u
	end

	def attempt( user , pass)
		auth = User.find_by(email: user)
		if not auth.nil?
			@state = true
			@name  = user.split('@')[0]
		end
	end

	def logout()
		@state = false
		@name = ""
	end


	def logged
		return @state
	end

	def guest
		return not(@state)
	end

	def name
		return @name
	end
	
	def initialize
		@state=false
		@name=""
	end
	
	private 
		@u	
	
end
