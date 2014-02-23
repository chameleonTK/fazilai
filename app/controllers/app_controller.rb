class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index , :createdomain , :loadallserver , :deleteserver , :loadallproject, :createproject , :deleteproject , :updateserver , :detailserver , :detailproject , :updateproject]
	before_filter :guest, :only => [ :index ]
	before_filter :validate , :only => [ :profiledata]
	skip_before_filter :verify_authenticity_token, :only => [:createdomain , :loadallserver , :deleteserver , :loadallproject, :createproject , :deleteproject , :updateserver , :detailserver , :detailproject , :updateproject]

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

	def log
		
	end

	def loadallproject
		server_id = params[:server_id].to_i
		all_proj = Proj.where('server_id = ?',server_id)
		if all_proj.empty? then
			render text: server_id
		else
			list_proj = Array.new
			all_proj.each do |x|
				list_proj.push(setFormatProjectName(x))
			end
			sendMessageAllProject = "["+list_proj.join(",")+"]"
			render text: sendMessageAllProject
		end
	end

	def createproject
		checkValidationName = isProjectName(params[:name])

		sendMessageValidationName = "name:"+"'"+checkValidationName+"'"
		sendMessageValidationPath = "path:"+"'"+"Accept"+"'"
		sendMessageValidationDetail = "detail:"+"'"+"Accept"+"'"
		if checkValidationName=="Accept" then
			saveProjectToDB(params[:name],params[:path],fillPathProject(params[:detail]),params[:server_id])
		end

		render text: "{"+sendMessageValidationName+","+sendMessageValidationPath+","+sendMessageValidationDetail+"}"
	end

	def deleteproject
		u = Auth.user
		indexDelete = params[:index]
		checkServer = Server.where('user_id = ? and sid = ? ',u.id,params[:server_id])
		all_delete_project = Proj.where('server_id = ? and pid = ?',params[:server_id],indexDelete)

		if checkServer.empty? || all_delete_project.empty? then
			render text: ""
		else
			all_delete_project.destroy_all
			render text: indexDelete
		end
	end

	def detailproject
		indexProject = params[:index]
		project = Proj.find_by(pid: indexProject)
		render text: setFormatProjectName(project)
	end

	def updateproject
		checkValidationName = isProjectName(params[:name])

		sendMessageValidationName = "name:"+"'"+checkValidationName+"'"
		sendMessageValidationPath = "path:"+"'"+"Accept"+"'"
		sendMessageValidationDetail = "detail:"+"'"+"Accept"+"'"
		if checkValidationName=="Accept" then
			updateProjectToDB(params[:name],params[:path],fillPathProject(params[:detail]),params[:index])
		end

		render text: "{"+sendMessageValidationName+","+sendMessageValidationPath+","+sendMessageValidationDetail+"}"
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
			all_delete_project = Proj.where('server_id = ?',indexDelete)
			all_delete.destroy_all
			all_delete_project.destroy_all
			render text: indexDelete
		end
	end


	def createdomain
		checkValidationName = isNameDomain(params[:name],0)

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

	def detailserver
		u = Auth.user
		indexServer = params[:index]
		if isValidServerID(u.id,indexServer) == true then
			server = Server.find_by(sid: indexServer)
			render text: setFormatServerNameFull(server)
		else
			render text: "Error: Not Permit."
		end
	end

	def updateserver
		indexServer = params[:index]

		checkValidationName = isValidNameUpdateDomain(params[:name],indexServer)

		sendMessageValidationName = "name:"+"'"+checkValidationName+"'"
		sendMessageValidationDomain = "domain:"+"'"+isDomainName(params[:domain])+"'"
		sendMessageValidationPort = "port:"+"'"+isPort(params[:port])+"'"
		sendMessageValidationUsername = "username:"+"'"+"Accept"+"'"
		sendMessageValidationPassword = "password:"+"'"+"Accept"+"'"

		if isDomainName(params[:domain])=='Accept' && isPort(params[:port])=='Accept' && checkValidationName=='Accept'  then
			updateDomainToDB(params[:name],params[:domain],params[:username],params[:password],params[:port],indexServer)
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

	def updateDomainToDB(name,domain,username,password,port,index)

		server_update = Server.find_by(sid: index)
		server_update[:name] = name
		server_update[:domain] = domain
		server_update[:port] = port
		server_update[:suser] = username
		server_update[:spass] = password

		if server_update.save
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

	def isNameDomain(name,sid)
		u = Auth.user

		if name.length < 3 then
			return 'Name: Lenght more than 3'
		else
			all_name = Server.where('user_id = ? AND sid <> ?',u.id,sid)
			all_name.each do |x|
				if x[:name]==name then
					return 'Name: This name is already in your list. '
				end
			end
		end
		return 'Accept'
	end

	def isValidServerID (uid,index)
		checkServer = Server.where('user_id = ? and sid = ? ',uid,index)
		if checkServer.empty? then
			return false
		end
		return true
	end

	def isValidNameUpdateDomain(name,index)
		u = Auth.user
		checkValidName = isNameDomain(name,index);
		if checkValidName == 'Accept' && isValidServerID(u.id,index) == true then
			return "Accept"
		end
		return checkValidName
	end

	def setFormatServerName(server)
			indexFormat = "index:"+"'"+server[:sid].to_s+"'"
			serverNameFormat = "name:"+"'"+server[:name]+"'"
			domainNameFormat = "domain:"+"'"+server[:domain]+"'"
			portFormat = "port:"+"'"+server[:port].to_s+"'"

			summaryFormat =  "{"+indexFormat+","+serverNameFormat+","+domainNameFormat+","+portFormat+"}"
			return summaryFormat
	end
	def setFormatServerNameFull(server)
			serverFormat = "name:"+"'"+server[:name]+"'"
			domainFormat = "domain:"+"'"+server[:domain]+"'"
			usernameFormat = "username:"+"'"+server[:suser]+"'"
			passwordFormat = "password:"+"'"+server[:spass]+"'"
			portFormat = "port:"+"'"+server[:port].to_s+"'"

			summaryFormat =  "{"+serverFormat+","+domainFormat+","+usernameFormat+","+passwordFormat+","+portFormat+"}"
			return summaryFormat
	end



	def setFormatProjectName(project)
			indexFormat = "index:"+"'"+project[:pid].to_s+"'"
			projectNameFormat = "name:"+"'"+project[:name]+"'"
			pathNameFormat = "path:"+"'"+project[:path]+"'"
			detailFormat = "detail:"+"'"+project[:detail].to_s+"'"

			summaryFormat =  "{"+indexFormat+","+projectNameFormat+","+pathNameFormat+","+detailFormat+"}"
			return summaryFormat
	end

	def saveProjectToDB(name,path,detail,server_id)
		u = Auth.user

		proj_new = Proj.new
		proj_new[:name] = name
		proj_new[:path] = path
		proj_new[:detail] = detail
		proj_new[:server_id] = server_id
		if proj_new.save 
			return true
		end
		return false
	end

	def updateProjectToDB(name,path,detail,index)
		proj_new = Proj.find_by(pid: index)
		proj_new[:name] = name
		proj_new[:path] = path
		proj_new[:detail] = detail
		if proj_new.save 
			return true
		end
		return false
	end

	def isProjectName(name)
		if name.length < 3 then
			return "Name length more than 3"
		end
		return "Accept"
	end

	def fillPathProject(path)
		if path.length ==0 then
			return "/"
		end
		return path
	end

	private :isDomainName , :isPort	, :isNameDomain ,:saveDomainToDB, :setFormatServerName , :saveProjectToDB , :isProjectName , :isValidServerID , :isValidNameUpdateDomain , :updateDomainToDB , :setFormatServerNameFull , :updateProjectToDB


end
