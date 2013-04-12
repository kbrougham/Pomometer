class Task < ActiveRecord::Base
  attr_accessible :description, :effort, :name, :project_id
  belongs_to :project
  validates :name, :description, :effort, :project_id, :presence => true
end
