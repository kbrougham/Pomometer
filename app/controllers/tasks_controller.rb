class TasksController < ApplicationController
  before_filter :auth_access, only: [:edit, :update, :destroy, :new, :create]

  def auth_access
    if session[:admin_id].nil?
      redirect_to root_url
    end
  end
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.order("name ASC")
    session[:current_task] = nil 
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    #figure out how to module this?
    @DEFAULT_TIME_ZONE = "Eastern Time (US & Canada)"

    if session[:selected_time_zone].nil?
      session[:selected_time_zone] = @DEFAULT_TIME_ZONE
    end

    Time.zone = session[:selected_time_zone]

    @task = Task.find(params[:id])

    if params[:keep_filter].nil?
      @results = Result.where(task_id: params[:id]).order("lower(goal) ASC")
    else
      #session will only be blank if user tries to intentionally break the website
      #and screw those users.
      if session[:start_date].nil?
        @results = Result.where(task_id: params[:id]).order("lower(goal) ASC")
      else
        @results = Result.where(started_at: session[:start_date].beginning_of_day..session[:end_date].end_of_day, task_id: params[:id]).order("lower(goal) ASC")
      end
    end

    session[:current_task] = params[:id]
    if @task.milestone_id.nil?
      session[:current_milestone] = nil
    else
      session[:current_milestone] = Milestone.find(@task.milestone_id)
    end
    
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @project = Project.find(session[:current_project])
    @milestones = Milestone.where(project_id: session[:current_project]).map{ |m| [ m.name, m.id ] }
    session[:current_task] = nil 
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @project = Project.where(:id => @task.project_id).all
    @milestones = Milestone.all.map{ |m| [ m.name, m.id ] }
    @effort_selected = @task.effort
    @milestone_selected = @task.milestone_id
    @completed_selected = @task.completed
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    #@project = Project.where(:id => @task.project_id).all
    @project = Project.find(session[:current_project])
    @milestones = Milestone.where(project_id: session[:current_project]).map{ |m| [ m.name, m.id ] }
    session[:current_task] = @task.id

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    @project = Project.where(:id => @task.project_id).all

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @project, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @project = Project.where(:id => @task.project_id).all
    @task.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end

  def set_time_zone
    session[:selected_time_zone] = params[:selected_time_zone]
    task = Task.find(params[:id])

    respond_to do |format|
      if request.xhr?
        format.json { head :no_content }
      end
    end
  end
end
