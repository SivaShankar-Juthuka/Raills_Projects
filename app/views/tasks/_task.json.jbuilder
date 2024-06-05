json.extract! task, :id, :task_title, :description, :completed, :created_at, :updated_at
json.url task_url(task, format: :json)
