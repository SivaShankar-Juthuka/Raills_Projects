# app/api/v1/tasks.rb
class TaskManagementSystem::V1::Tasks < Grape::API
  resource :tasks do

    # GET /api/v1/tasks
    desc 'Return a list of tasks'
    get do
      Task.all
    end

    # GET /api/v1/tasks/:id
    desc 'Return a task'
    params do
      requires :id, type: Integer, desc: 'Task ID'
    end
    get ':id' do
      Task.find(params[:id])
    end

    # POST /api/v1/tasks
    desc 'Create a task'
    params do
      requires :task_title, type: String, desc: 'Title of the task'
      requires :description, type: String, desc: 'Description of the task'
      requires :completed, type: Boolean, desc: 'Task completion status'
    end
    post do
      Task.create({
        task_title: params[:task_title],
        description: params[:description],
        completed: params[:completed]
      })
    end

    # PUT /api/v1/tasks/:id
    desc 'Update a task'
    params do
      requires :id, type: Integer, desc: 'Task ID'
      optional :task_title, type: String, desc: 'Title of the task'
      optional :description, type: String, desc: 'Description of the task'
      optional :completed, type: Boolean, desc: 'Task completion status'
    end
    put ':id' do
      task = Task.find(params[:id])
      task.update({
        task_title: params[:task_title],
        description: params[:description],
        completed: params[:completed]
      })
      task
    end

    # DELETE /api/v1/tasks/:id
    desc 'Delete a task'
    params do
      requires :id, type: Integer, desc: 'Task ID'
    end
    delete ':id' do
      Task.find(params[:id]).destroy
    end
  end
end