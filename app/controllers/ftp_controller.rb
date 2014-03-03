require 'net/ftp'

class FtpController < ApplicationController
	before_filter :setvar , :only => [:listfile,:getfile,:putfile,:mkdir,:mkfile]
	after_filter :clearvar , :only => [:listfile,:getfile,:putfile,:mkdir,:mkfile]

	def setvar
		is_error = false
		e = ""
		#session[:server] = 'ftp.curve.in.th'
		#session[:username] = 'curveinth' #params["username"]
		#session[:password] = '2curveTK' #params["password"]
		@server = session[:server]
		begin
			@ftp = Net::FTP.new(session[:server])
			begin
				@ftp.passive = true
				@ftp.login(session[:username], session[:password])
			rescue
				is_error = true
				e = "loginError"
			end
		rescue
			is_error = true
			e = "connectError"
		end

		if is_error
			render text: e
		end
	end

	def setsession
		pid = params[:pid]
		p = Proj.find(pid)
		s = p.server
		session[:server] = s.domain
		session[:username] = s.suser
		session[:password] = s.spass
		time = Time.new
		t = time.strftime("%a, %d %b %Y %H:%M:%S")
		u = Auth.user
		log = u.obj.logs.new
		log.proj_id = pid
		log.starttime = t
		log.lefttime = t
		log.save
		session[:lid] = log.lid
		render text: "pass"
	end

	def clearvar
		log = Log.find(session[:lid])
		time = Time.new
		t = time.strftime("%a, %d %b %Y %H:%M:%S")
		log.lefttime = t
		log.save
		@ftp.close
	end

	def chdir (ftp,dirname,format)
		@dir = ""
		dirname.each_with_index do | dr , i |
			if i == dirname.length-1
				if format.nil?
					ftp.chdir(dr)
					@dir += "/"+dr
				end
			else
				ftp.chdir(dr)
				@dir += "/"+dr
			end
		end
		return ftp
	end

	def listfile
		dir_ = params["dirname"]
		if not dir_.nil?
			dirname = dir_.split("/")
			@ftp = chdir(@ftp,dirname,params["format"])
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
	
	def mkdir
		folder = params["folder"]
		dir_ = params["dirname"]
		
		is_error = false
		begin
			@ftp.mkdir(dir_+"/"+folder)
		rescue
			is_error = true
		end

		if is_error
			render text: "error : "+dir_+"/"+folder
		else
			render text: "create directory pass"
		end
	end

	def mkfile
		file = params["file"]
		dir_ = params["dirname"]
		local = "tmp_server/"+file

		filenames = @ftp.nlst(dir_) 				
		f = open(local, "w")
		f.write("")
 		f.close

		is_error = false
		e = ""
		begin
			@ftp.putbinaryfile(local,dir_+"/"+file,1024)
		rescue
			is_error = true
		end

		if is_error
			render text: "error"
		else
			render text: "create '"+file+"' successful"
		end
	end
	
	def putfile
		filename = ""
		dir_ = params["dirname"]
		dirname = dir_.split("/")
		filename = dirname[dirname.length-1]
		dirname = dirname.take(dirname.length-1).join("/")
		local = "tmp_server/"+filename+"."+params["format"]

		filenames = @ftp.nlst(dirname) 				

		doc = params["doc"]
		f = open(local, "w")
		f.write(doc)
 		f.close

		is_save = false
		is_error = false
		e = ""
		filenames.each do |file|
			if file.include? filename
				begin
					@ftp.putbinaryfile(local,file,1024)
				rescue
					is_error = true
					e = "permissionError"
				end
				is_save = true
				break
			end
		end

		if is_error
			render text: e
		else
			if is_save
				render text: "accept"
			else
				render text: "denine"
			end
		end
	end

	def getfile
		filename = ""
		dir_ = params["dirname"]
		ret = {}
		if not dir_.nil?
			dirname = dir_.split("/")
			filename = dirname[dirname.length-1]
			dirname = dirname.take(dirname.length-1).join("/")
			#@ftp = chdir(@ftp,dirname)
			#@ftp.gettextfile(filename)
			if params["format"].nil?
				ret["code"] = ""
				ret["type"] = "error"
				ret["error"] = "no format?"
			else
				type = { 
					"php" => "application/x-httpd-php",
					"html" => "text/html" ,
					"js" => "text/javascript",
					"css" => "text/css",
					"rb" => "text/x-ruby",
					"py" => "text/x-python",
					"txt" => "text/html"
				}
				if type.has_key?(params["format"])
				
					ret["code"] = ""
					ret["type"] = type[params["format"]]
					filenames = @ftp.nlst(dirname) 
					
					#fileList = @ftp.list(filename+"*")
					data = "not find file"
				  	filenames.each do |file|

						if file.include? filename
							local = "tmp_server/"+filename+"."+params["format"]
							@ftp.getbinaryfile(file,local,1024)
							f = open(local, "r")
							data = f.read
 							f.close
							break
						end
				   end
					ret["code"] = data
					#render text: filename
				else	
					ret["code"] = ""
					ret["type"] = params["format"]
					ret["error"] = "not support type"
				end
			end
		else
			ret["code"] = "error"
			ret["type"] = "error"
			ret["error"] = "not dirname"
		end

		render json: ret	

	end

end
