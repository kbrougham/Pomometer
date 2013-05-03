class ReportsController < ApplicationController

	# /reports
  def index
  	@projects = Project.all
  end

    # /reports/1
  def show
    #temporary EST hard code for time's sake
    Time.zone = "Eastern Time (US & Canada)"

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

  	#@results = nil
 	
  	#@tasks.each do |task|
  	#	if @results.nil?
  	#		@results = Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day, task_id: task.id)
  	#	else
  	#		@results << Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day, task_id: task.id)
  	#	end
  	#end

    @results = []
    @tasks.each do |task|
      temp = Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day, task_id: task.id)
      for t in temp
        @results << t
      end
    end

    @results.sort_by!{ |r| r.goal.downcase }
  end

	# /reports/all
	def all
    #temporary EST hard code for time's sake
    Time.zone = "Eastern Time (US & Canada)"

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
  	
    @results = (Result.where(started_at: @start_date.beginning_of_day..@end_date.end_of_day)).sort_by!{ |r| r.goal.downcase }
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
	
    @pomodoro_completed, @hours_worked, @minutes_worked, @minutes_worked_range_1_15, @minutes_worked_range_16_30, @minutes_worked_range_31_45, @minutes_worked_range_46_60 = Result.statistics_of_given_results(@results)
  end
end
