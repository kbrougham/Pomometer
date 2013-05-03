class Task < ActiveRecord::Base
  attr_accessible :completed, :description, :effort, :name, :project_id, :milestone_id
  belongs_to :project
  belongs_to :milestone
  has_many :results
  
  validates :name, :description, :effort, :project_id, :presence => true

  #Will return all tasks, the tasks without a milestone, then the tasks with/ordered by milestone
  def self.task_list_find_and_separation(sent_project_id)
  	@tasks = Task.where("project_id = ? AND milestone_id IS NOT NULL", sent_project_id).order("milestone_id, lower(name) ASC")
    @tasks_without_milestone = Task.where(project_id: sent_project_id, milestone_id: nil).order("lower(name) ASC")
    @tasks_by_milestone = @tasks.group_by { |task| Milestone.find(task.milestone_id).name.downcase }

    return @tasks, @tasks_without_milestone, @tasks_by_milestone
  end
end
