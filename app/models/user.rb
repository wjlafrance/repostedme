class User < ActiveRecord::Base
  attr_accessible :token, :username, :userid

  validates_presence_of :token, :username, :userid
  validates_uniqueness_of :token
end
