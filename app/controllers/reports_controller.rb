class ReportsController < ApplicationController
	#temporary EST hard code for time's sake
	Time.zone = "EST"


	# /reports
  def index
  	@projects = Project.all
  end

    # /reports/1
  def show
  	if session[:start_date].nil?
        session[:start_date] = Date.today - 1.month
        session[:end_date] = Date.today
    end
    
    if !params[:start_date_year].nil?
      session[:start_date] = Date.new(params[:start_date_year].to_i,params[:start_date_month].to_i,params[:start_date_day].to_i)
      session[:end_date] = Date.new(params[:end_date_year].to_i,params[:end_date_month].to_i,params[:end_date_day].to_i)    
    end

    @start_date = session[:start_date].to_date
    @end_date = session[:end_date].to_date

  	@project = Project.find(params[:id])
  	@tasks = Task.where(project_id: @project.id)
 	
    @task_id_array = []

  	@tasks.each do |task|
        @task_id_array << task.id
  	end

    @results = Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day, task_id: task.id)
  end

	# /reports/all
	def all
		@tasks = Task.all
		if session[:start_date].nil?
  			session[:start_date] = Date.today - 1.month
  			session[:end_date] = Date.today
  	end
  	
    if !params[:start_date_year].nil?
      session[:start_date] = Date.new(params[:start_date_year].to_i,params[:start_date_month].to_i,params[:start_date_day].to_i)
      session[:end_date] = Date.new(params[:end_date_year].to_i,params[:end_date_month].to_i,params[:end_date_day].to_i)    
    end

    @start_date = session[:start_date].to_date
  	@end_date = session[:end_date].to_date
  	
    @results = Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day)
	end

    # /reports/statistics
  def statistics

  	if session[:start_date].nil?
        session[:start_date] = Date.today - 1.month
        session[:end_date] = Date.today
    end
    
    if !params[:start_date_year].nil?
      session[:start_date] = Date.new(params[:start_date_year].to_i,params[:start_date_month].to_i,params[:start_date_day].to_i)
      session[:end_date] = Date.new(params[:end_date_year].to_i,params[:end_date_month].to_i,params[:end_date_day].to_i)    
    end

    @start_date = session[:start_date].to_date
    @end_date = session[:end_date].to_date

  	@results = Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day)
  	#@earliest_result = DateTime.now
	
  	@pomodoro_completed = @results.count

  	@hours_worked = 0
  	@minutes_worked = 0

  	@minutes_worked_range_1_15 = 0
  	@minutes_worked_range_16_30 = 0
  	@minutes_worked_range_31_45 = 0
  	@minutes_worked_range_46_60 = 0

  	@results.each do |result|
  		@minutes_worked = @minutes_worked + result.duration

  		#if result.started_at < @earliest_result
  		#	@earliest_result = result.started_at
  		#end
  	
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
