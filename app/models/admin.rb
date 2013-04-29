class Admin < ActiveRecord::Base
  attr_accessible :password, :role, :username
  
  validates :username, :password, :role, presence: true
  validates :username , uniqueness: true
  validates_length_of :username, minimum: 6
  validates_length_of :username, maximum: 20
  validates_length_of :password, minimum: 6
  validates_length_of :password, maximum: 12
end
