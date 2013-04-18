class ResultsController < ApplicationController
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
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])

    #temporarily hardcoded to an EST fix
    @result.started_at = @result.started_at.change(hour: @result.started_at.hour-4)
    @result.ended_at = @result.ended_at.change(hour: @result.ended_at.hour-4)
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(params[:result])
    @task = Task.where(:id => @result.task_id).all

    #subtraction returns seconds, so divide by 60 to get minutes
    @result.duration = ((@result.ended_at - @result.started_at) / 60).to_i

    #temporarily hardcoded to an EST fix
    @result.started_at = @result.started_at.change(hour: @result.started_at.hour+4)
    @result.ended_at = @result.ended_at.change(hour: @result.started_at.hour+4)

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
    @result = Result.find(params[:id])
    #subtraction returns seconds, so divide by 60 to get minutes
    @result.duration = ((@result.ended_at - @result.started_at) / 60).to_i

    @task = Task.where(:id => @result.task_id).all
    
    respond_to do |format|
      if @result.update_attributes(params[:result])

        #temporarily hardcoded to an EST fix
        @result.started_at = @result.started_at.change(hour: @result.started_at.hour+4)
        @result.ended_at = @result.ended_at.change(hour: @result.started_at.hour+4)

        #subtraction returns seconds, so divide by 60 to get minutes
        @result.duration = ((@result.ended_at - @result.started_at) / 60).to_i
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