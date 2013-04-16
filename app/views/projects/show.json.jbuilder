

json.(@project, :name)
json.tasks @project.tasks, :id, :name, :description, :effort