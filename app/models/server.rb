class Server < ActiveRecord::Base
	belongs_to :user
	has_many :projs
end
