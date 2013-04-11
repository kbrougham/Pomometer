class Task < ActiveRecord::Base
  attr_accessible :description, :effort, :name, :project_id

  belongs_to :project
end
