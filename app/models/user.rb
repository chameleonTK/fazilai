class User < ActiveRecord::Base
	has_many :servers
	has_many :logs
	has_many :ownachieves
	has_many :achievements , through: :ownachieves
	
end
