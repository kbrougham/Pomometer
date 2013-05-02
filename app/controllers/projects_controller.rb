class ProjectsController < ApplicationController
  before_filter :auth_access, only: [:edit, :update, :destroy, :new, :create]

  def auth_access
    if session[:admin_id].nil?
      redirect_to root_url
    end
  end

  # GET /projects
  # GET /projects.json

  def index
    @projects = Project.order("lower(name) ASC")
    session[:current_project] = nil 
    session[:current_task] = nil 
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @milestones = Milestone.order("lower(name) ASC")

    if params[:filter] == true
      
    else
      @tasks = Task.where("project_id = ? AND milestone_id IS NOT NULL", params[:id]).order("milestone_id, name ASC")
      @tasks_without_milestone = Task.where(project_id: params[:id], milestone_id: nil).order("name ASC")
      @tasks_by_milestone = @tasks.group_by { |task| Milestone.find(task.milestone_id).name }
    end
    
    session[:current_project] = @project.id
    session[:current_task] = nil  
    session[:current_milestone] = nil
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    session[:current_project] = nil 
    session[:current_task] = nil 
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    session[:current_project] = @project.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
