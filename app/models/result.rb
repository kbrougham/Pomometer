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

  #will return in the order #completed, hours, minutes, 1-15 range minutes
  #16-30 range minutes, 31-45 range minutes, 46-60 range minutes
  def self.statistics_of_given_results (sent_results)
    @pomodoro_completed = sent_results.count

    @hours_worked = 0
    @minutes_worked = 0

    @minutes_worked_range_1_15 = 0
    @minutes_worked_range_16_30 = 0
    @minutes_worked_range_31_45 = 0
    @minutes_worked_range_46_60 = 0

    sent_results.each do |sent_result|
      @minutes_worked = @minutes_worked + sent_result.duration
    
      if (sent_result.duration <= 15)
        @minutes_worked_range_1_15 += 1
      elsif (sent_result.duration <= 30)
        @minutes_worked_range_16_30 += 1
      elsif (sent_result.duration <= 45)
        @minutes_worked_range_31_45 += 1
      else
        @minutes_worked_range_46_60 += 1
      end
    end

    @hours_worked = @minutes_worked / 60
    @minutes_worked = @minutes_worked % 60 

    return @pomodoro_completed, @hours_worked, @minutes_worked, @minutes_worked_range_1_15, @minutes_worked_range_16_30, @minutes_worked_range_31_45, @minutes_worked_range_46_60
  end
end