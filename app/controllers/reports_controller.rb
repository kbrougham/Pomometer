class ReportsController < ApplicationController
	# /reports
  def index
  	@projects = Project.all
  end

    # /reports/1
  def show
  	@project = Project.find(params[:id])
  end

    # /reports/all
  def all
  	@results = Result.all

  	@pomodoro_completed = @results.count

  	@hours_worked = 0
  	@minutes_worked = 0

  	@minutes_worked_range_1_15 = 0
  	@minutes_worked_range_16_30 = 0
  	@minutes_worked_range_31_45 = 0
  	@minutes_worked_range_46_60 = 0

  	@results.each do |result|
  		@minutes_worked = @minutes_worked + result.duration

	if (result.duration <= 15)
		@minutes_worked_range_1_15 += 1
	elsif (result.duration <= 30)
		@minutes_worked_range_16_30 += 1
	elsif (result.duration <= 45)
		@minutes_worked_range_31_45 += 1
	else
		@minutes_worked_range_46_60 += 1
  	end

  	@hours_worked = @minutes_worked / 60
  	@minutes_worked = @minutes_worked % 60
  end
end
