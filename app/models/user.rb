class User < ActiveRecord::Base
	has_many :servers
	has_many :logs
	has_many :ownachievements
	has_many :achievements , through: :ownachievements
	
end
