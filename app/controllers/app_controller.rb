require 'net/ftp'

class AppController < ApplicationController
	skip_before_filter :logged, :only => [ :index ]
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


end
