# app/api/v1/tasks.rb
class Api::V1::Tasks < Grape::API
    resource :tasks do
        before do
            authenticate!
        end

        desc 'Return list of tasks'
        params do
            optional :q, type: Hash, desc: 'Search and filtering parameters'
            optional :page, type: Integer, desc: 'Page number', default: 1
            optional :per_page, type: Integer, desc: 'Number of items per page', default: 10
        end
        get do
            tasks = Task.ransack(params[:q]).result
            tasks = paginate(tasks)
            present tasks
        end
    
        desc 'Create a task'
        params do
            requires :task_name, type: String, desc: 'Task name'
            requires :status, type: String, desc: 'Status'
            requires :due_date, type: DateTime, desc: 'Due date'
        end
        post do
            task = Task.create!(
            task_name: params[:task_name],
            status: params[:status],
            due_date: params[:due_date],
            user_id: Current.user.id
            )
            present task
        end
    
        desc 'Return a task'
        params do
            requires :id, type: Integer, desc: 'Task ID'
        end
        get ':id' do
            task ||= Task.find_by(id: params[:id])
            if task.present?
                present task
            else
                error!('Task Not Found', 404)
            end
        end
    
        desc 'Update a task'
        params do
            requires :id, type: Integer, desc: 'Task ID'
            optional :task_name, type: String, desc: 'Task name'
            optional :status, type: String, desc: 'Status'
            optional :due_date, type: DateTime, desc: 'Due date'
        end
        put ':id' do
            task = Task.find(params[:id])
            error!('You are not authorized to do this action.', 403) unless task.user_id == Current.user.id || Current.user.admin?
            task.update!(params)
            present task
        end
    
        desc 'Delete a task'
        params do
            requires :id, type: Integer, desc: 'Task ID'
        end
        delete ':id' do
            task = Task.find(params[:id])
            error!('You are not authorized to do this action.', 403) unless task.user_id == Current.user.id || Current.user.admin?
            task.destroy
            { message: 'Task deleted successfully' }
        end
    end
end
  