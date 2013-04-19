class Result < ActiveRecord::Base
  attr_accessible :duration, :ended_at, :goal, :notes, :started_at, :task_id
  belongs_to :task

  validates :goal, :notes, :duration, :presence => true
  before_save :end_date_after_start_date

  def end_date_after_start_date
  	if started_at >= ended_at
		errors.add(:ended_at, " must be after Started At.")
	end 
  end
end