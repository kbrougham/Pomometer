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
  	puts params[:start_date_year]
  	puts params[:start_date_month]
  	puts params[:start_date_day]

  	puts params[:end_date_year]
  	puts params[:end_date_month]
  	puts params[:end_date_day]

  	if params[:start_date_year].nil?
  		@start_date = Date.today - 1.month
  		@end_date = Date.today
  	else
  		@start_date = Date.new(params[:start_date_year].to_i,params[:start_date_month].to_i,params[:start_date_day].to_i)
  		@end_date = Date.new(params[:end_date_year].to_i,params[:end_date_month].to_i,params[:end_date_day].to_i)
  	end
  	

  	@results = Result.all
  	@earliest_result = DateTime.now
	
  	@pomodoro_completed = @results.count

  	@hours_worked = 0
  	@minutes_worked = 0

  	@minutes_worked_range_1_15 = 0
  	@minutes_worked_range_16_30 = 0
  	@minutes_worked_range_31_45 = 0
  	@minutes_worked_range_46_60 = 0

  	@results.each do |result|
  		@minutes_worked = @minutes_worked + result.duration

  		if result.started_at < @earliest_result
  			@earliest_result = result.started_at
  		end
  	
      	if (result.duration <= 15)
    		@minutes_worked_range_1_15 += 1
      	elsif (result.duration <= 30)
    		@minutes_worked_range_16_30 += 1
      	elsif (result.duration <= 45)
    		@minutes_worked_range_31_45 += 1
      	else
    		@minutes_worked_range_46_60 += 1
      	end
    end 

  	@hours_worked = @minutes_worked / 60
  	@minutes_worked = @minutes_worked % 60  
  end
end
