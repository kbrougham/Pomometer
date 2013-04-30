class Result < ActiveRecord::Base
  attr_accessor :milestone_start, :milestone_end
  attr_accessible :duration, :ended_at, :goal, :notes, :started_at, :task_id, :milestone_start, :milestone_end

  belongs_to :task

  validates :goal, :notes, :duration, :presence => true
  validate :result_date_in_milestone_range, :negative_duration, :end_date_after_start_date

# max duration 60 minutes
  def end_date_after_start_date
  	if started_at >= ended_at
		errors.add(:ended_at, " must be after Started At.")
	end 
  end

  def result_date_in_milestone_range
    if milestone_start != 0 && milestone_end != 0
	    if started_at < milestone_start
        errors.add(:started_at, " must be started after #{milestone_start}")
      end

      if ended_at > milestone_end
        errors.add(:ended_at, " must be ended before #{milestone_end}")
      end
    end
  end

  def negative_duration
  	if duration < 0
  		errors.add(:duration, " must not be negative")
  	end
  end

end