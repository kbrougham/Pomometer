class Admin < ActiveRecord::Base
  attr_accessible :password, :role, :username
end
