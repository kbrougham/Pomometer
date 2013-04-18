json.(@task, :name, :description, :effort)
json.results @task.results, :id, :goal, :notes, :duration, :started_at, :ended_at