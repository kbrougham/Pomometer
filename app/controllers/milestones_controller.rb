class MilestonesController < ApplicationController
  # GET /milestones
  # GET /milestones.json
  def index
    #figure out how to module this?
    @DEFAULT_TIME_ZONE = "Eastern Time (US & Canada)"

    if session[:selected_time_zone].nil?
      session[:selected_time_zone] = @DEFAULT_TIME_ZONE
    end

    Time.zone = session[:selected_time_zone]

    @milestones = Milestone.where(project_id: session[:current_project]).order("name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @milestones }
    end
  end

  # GET /milestones/1
  # GET /milestones/1.json
  def show
    Time.zone = session[:selected_time_zone]

    @milestone = Milestone.find(params[:id])
    @tasks = Task.where(milestone_id: params[:id]).order("name ASC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @milestone }
    end
  end

  # GET /milestones/new
  # GET /milestones/new.json
  def new
    Time.zone = session[:selected_time_zone]

    @milestone = Milestone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @milestone }
    end
  end

  # GET /milestones/1/edit
  def edit
    Time.zone = session[:selected_time_zone]

    @milestone = Milestone.find(params[:id])
  end

  # POST /milestones
  # POST /milestones.json
  def create
    Time.zone = session[:selected_time_zone]

    @milestone = Milestone.new(params[:milestone])

    respond_to do |format|
      if @milestone.save
        format.html { redirect_to @milestone, notice: 'Milestone was successfully created.' }
        format.json { render json: @milestone, status: :created, location: @milestone }
      else
        format.html { render action: "new" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /milestones/1
  # PUT /milestones/1.json
  def update
    Time.zone = session[:selected_time_zone]

    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        format.html { redirect_to @milestone, notice: 'Milestone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.json
  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to milestones_url }
      format.json { head :no_content }
    end
  end

  def set_time_zone
    session[:selected_time_zone] = params[:selected_time_zone]

    respond_to do |format|
      if request.xhr?
        format.json { head :no_content }
      end
    end
  end
end
