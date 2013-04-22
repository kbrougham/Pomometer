class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :tasks
  has_many :milestones
  validates :name, :presence => true
  validates :name, :uniqueness => true
end
