class Result < ActiveRecord::Base
  attr_accessible :duration, :ended_at, :goal, :notes, :started_at, :task_id
  belongs_to :task


end
