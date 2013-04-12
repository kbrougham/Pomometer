class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :tasks
  
  validates :name, :presence => true
  validates :name, :uniqueness => true
end
