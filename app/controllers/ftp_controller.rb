require 'net/ftp'

class FtpController < ApplicationController
	before_filter :setvar , :only => [:listfile,:getfile,:putfile]
	after_filter :clearvar , :only => [:listfile,:getfile,:putfile]

	def setvar
		session[:server] = 'ftp.curve.in.th'
		session[:username] = 'curveinth' #params["username"]
		session[:password] = '2curveTK' #params["password"]
		@server = session[:server]
		@ftp = Net::FTP.new(session[:server])
		@ftp.passive = true
		@ftp.login(session[:username], session[:password])

	end

	def clearvar
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
		filenames.each do |file|
			if file.include? filename
				@ftp.putbinaryfile(local,file,1024)
				is_save = true
				break
			end
		end

		if is_save
			render text: "accept"
		else
			render text: "denine"
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
