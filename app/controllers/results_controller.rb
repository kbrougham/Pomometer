class ResultsController < ApplicationController
  before_filter :auth_access

  def auth_access
    if session[:admin_id].nil?
      redirect_to root_url
    end
  end

  # GET /results
  # GET /results.json
  def index
    @results = Result.all
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])
  end

  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    Time.zone= session[:selected_time_zone]
    puts session[:selected_time_zone]
    puts Time.zone
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
    Time.zone=session[:selected_time_zone]
end

  # POST /results
  # POST /results.json
  def create
    Time.zone=session[:selected_time_zone]
    @result = Result.new(params[:result])
    @task = Task.where(:id => @result.task_id).all

    if @result.duration.nil?
      @result.errors.add(:duration, " must not be empty.")
    elsif @result.duration <= 0
      @result.duration_check = true
    else
      #the end result is the start result + duration in minutes
      @result.ended_at = @result.started_at + (@result.duration*60)

      #convert to UTC for storing
      @result.started_at = @result.started_at.in_time_zone("UTC")
      @result.ended_at = @result.ended_at.in_time_zone("UTC")
      puts Time.zone

      if session[:current_milestone].nil?
        @result.errors.add(:duration, " nothing")
      else
        if @result.started_at < session[:current_milestone].starts_at
          @result.milestone_start = session[:current_milestone].starts_at
        end

        if @result.ended_at > session[:current_milestone].ends_at
          @result.milestone_end = session[:current_milestone].ends_at
        end
      end

      #if session[:current_milestone].nil?
      #  @result.milestone_start = 0
      #  @result.milestone_end = 0
      #else
      #  @result.milestone_start = session[:current_milestone].starts_at
      #  @result.milestone_end = session[:current_milestone].ends_at
      #end
    end
    
    
    respond_to do |format|
      if @result.save
        format.html { redirect_to @task, notice: 'Result was successfully created.' }
        format.json { render json: @result, status: :created, location: @result }    
      else
        format.html { render action: "new" }
        format.json { render json: @result.errors, status: :unprocessable_entity }      
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.json
  def update
    Time.zone=session[:selected_time_zone]
    @result = Result.find(params[:id])
    #subtraction returns seconds, so divide by 60 to get minutes
    @result.duration = ((@result.ended_at - @result.started_at) / 60).to_i

    @task = Task.where(:id => @result.task_id).all
    
    respond_to do |format|
      if @result.update_attributes(params[:result])

        #the end result is the start result + duration in minutes
        @result.ended_at = @result.started_at + (@result.duration*60)
        @result.save

        format.html { redirect_to @task, notice: 'Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @task = Task.where(:id => session[:current_task]).all
    @result.destroy

    respond_to do |format|
      format.html { redirect_to @task }
      format.json { head :no_content }
    end
  end
end
