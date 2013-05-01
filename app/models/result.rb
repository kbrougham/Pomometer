class Result < ActiveRecord::Base

  attr_accessor :milestone_start, :milestone_end, :duration_check
  attr_accessible :duration, :ended_at, :goal, :notes, :started_at, :task_id, :milestone_start, :milestone_end, :duration_check

  belongs_to :task

  validates :goal, :notes, :duration, :presence => true
  
  validate :result_date_in_milestone_range
  #validate :end_date_after_start_date
  validate :negative_duration

# max duration 60 minutes
  #def end_date_after_start_date
  #  if started_at >= ended_at
  #    errors.add(:ended_at, " must be after Started At.")
  #  end 
  #end

  def result_date_in_milestone_range
      if milestone_start != nil
        errors.add(:started_at, " must be started after #{milestone_start}")
      end

      if milestone_end != nil
        errors.add(:ended_at, " must be ended before #{milestone_end}")
      end
  end

  def negative_duration
      if duration_check == true
        errors.add(:duration, " must be greater than 0")
      end
  end

  

end