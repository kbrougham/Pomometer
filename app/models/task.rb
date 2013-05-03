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

  #Will return all tasks, the tasks without a milestone, then the tasks with/ordered by milestone
  def self.date_filtered_task_list_find_and_separation(sent_project_id, sent_start_date, sent_end_date)
  	#all tasks within date range
  	@results = Result.where(started_at: sent_start_date.beginning_of_day..sent_end_date.end_of_day)
  	#get array of valid task ids
  	@task_ids = []
  	@results.each do |result|
  		@task_ids << result.task_id
  	end
  	#ensure unique task ids, don't need to repeat same task repeatedly
  	@task_ids.uniq

  	#get tasks that match above task_ids, AND project id
  	@tasks = Task.where(id: @task_ids, project_id: sent_project_id, milestone_id: !nil)
  	@tasks_without_milestone = Task.where(id: @task_ids, project_id: sent_project_id, milestone_id: nil)
  	@tasks_by_milestone = @tasks.group_by { |task| Milestone.find(task.milestone_id).name.downcase }

  	return @tasks, @tasks_without_milestone, @tasks_by_milestone
  end  
end
