require 'net/ftp'

class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index , :createdomain , :loadallserver , :deleteserver]
	before_filter :guest, :only => [ :index ]
	before_filter :validate , :only => [ :profiledata]
	skip_before_filter :verify_authenticity_token, :only => [:createdomain , :loadallserver , :deleteserver]
	before_filter :setvar , :only => [:listfile]
	after_filter :clearvar , :only => [:listfile]

	def setvar
		session[:server] = 'ftp.curve.in.th'
		session[:username] = 'curveinth' #params["username"]
		session[:password] = '2curveTK' #params["password"]
		@server = session[:server]
		@ftp = Net::FTP.new(session[:server])
		@ftp.login(session[:username], session[:password])

	end

	def clearvar
		@ftp.close
	end

	def index
	end

	def choose
	end

	def server
	end


	def validate
		u = Auth.user
		p= User.where(uid: u.id).take
		if params[:post][:oldpassword]==""
			flash[:error] = "Please enter old password"
				redirect_to profile_path()
		
		elsif params[:post][:newpassword]==""
			flash[:error] = "Please enter new password"
				redirect_to profile_path()
		
		elsif params[:post][:renewpassword]==""
			flash[:error] = "Please enter re new password"
				redirect_to profile_path()
		
		elsif p[:pass]==params[:post][:oldpassword]
			
			if params[:post][:newpassword]!=params[:post][:renewpassword]
			flash[:error] = "not match"
				flash[:error] = "You have failed two new passwords not match"
				redirect_to profile_path()
			end
		elsif
			flash[:error] = "You are not the owner"
			#flash[:error] =params[:post][:oldpassword]
			redirect_to profile_path()
		end		
	end

	def profiledata

			u = Auth.user
			user = User.find_by(uid: u.id)
			user.pass = params[:post][:newpassword]
			if user.save
				flash[:notice] = "You have successfully update."
				redirect_to profile_path()
			else
				flash[:error] = "You have failed to update"
				redirect_to profile_path()
			end
		
	end


	def listfile
		dir_ = params["dirname"]
		if not dir_.nil?
			@dir = ""
			dirname = dir_.split("/")
			dirname.each_with_index do | dr , i |
				if i == dirname.length-1
					if params["format"].nil?
						@ftp.chdir(dr)
						@dir += "/"+dr
					end
				else
					@ftp.chdir(dr)
					@dir += "/"+dr
				end
			end
		else
			@dir ="/"
		end
	
		ls = @ftp.list();
		ll = []
		ls.each do | ff |
			ff = ff.gsub(/ +/," ").split(/ /)
			#print ff[0],"    ",ff[8],"\n"
			ll.push({ :permission => ff[0], :filename => ff[8]})
		end
		render json: ll
	end
	def log
		render text: "log not yet"
	end


	def loadallserver
		u = Auth.user
		all_name = Server.where('user_id = ?',u.id)
		if all_name.empty? then
			render text: "[]"
		else
			list_server = Array.new
			all_name.each do |x|
				list_server.push(setFormatServerName(x))
			end
			sendMessageAllServer = "["+list_server.join(",")+"]"
			render text: sendMessageAllServer
		end
	end	

	def deleteserver
		u = Auth.user
		indexDelete = params[:index]
		all_delete = Server.where('user_id = ? and sid = ? ',u.id,indexDelete)
		if all_delete.empty? then
			render text: ""
		else
			all_delete.destroy_all
			render text: indexDelete
		end
	end


	def createdomain
		checkValidationName = isNameDomain(params[:name])

		sendMessageValidationName = "name:"+"'"+checkValidationName+"'"
		sendMessageValidationDomain = "domain:"+"'"+isDomainName(params[:domain])+"'"
		sendMessageValidationPort = "port:"+"'"+isPort(params[:port])+"'"
		sendMessageValidationUsername = "username:"+"'"+"Accept"+"'"
		sendMessageValidationPassword = "password:"+"'"+"Accept"+"'"

		if isDomainName(params[:domain])=='Accept' && isPort(params[:port])=='Accept' && checkValidationName=='Accept'  then
			saveDomainToDB(params[:name],params[:domain],params[:username],params[:password],params[:port])
		end

		render text: "{"+sendMessageValidationName+","+sendMessageValidationDomain+","+sendMessageValidationPort+","+sendMessageValidationUsername+","+sendMessageValidationPassword+"}"
	end




	def saveDomainToDB(name,domain,username,password,port)
		u = Auth.user

		server_new = Server.new
		server_new[:name] = name
		server_new[:domain] = domain
		server_new[:port] = port
		server_new[:suser] = username
		server_new[:spass] = password
		server_new[:user_id] = u.id
		if server_new.save
			return true
		end
		return false
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

	def isNameDomain(name)
		u = Auth.user

		if name.length < 3 then
			return 'Name: Lenght more than 3'
		else
			all_name = Server.where('user_id = ?',u.id)
			all_name.each do |x|
				if x[:name]==name then
					return 'Name: This name is already in your list. '
				end
			end
		end
		return 'Accept'
	end

	def setFormatServerName(server)
			indexFormat = "index:"+"'"+server[:sid].to_s+"'"
			serverNameFormat = "name:"+"'"+server[:name]+"'"
			domainNameFormat = "domain:"+"'"+server[:domain]+"'"
			portFormat = "port:"+"'"+server[:port].to_s+"'"

			summaryFormat =  "{"+indexFormat+","+serverNameFormat+","+domainNameFormat+","+portFormat+"}"
			return summaryFormat
	end

	private :isDomainName , :isPort	, :isNameDomain ,:saveDomainToDB, :setFormatServerName


end
