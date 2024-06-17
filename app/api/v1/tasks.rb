# app/api/v1/tasks.rb
class Api::V1::Tasks < Grape::API
    before { authenticate! }
    resource :tasks do
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
            task = Task.find_by(id: params[:id])
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
            task.update!(declared(params, include_missing: false))
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
  
      # Nested sub-tasks routes
        route_param :task_id do
            resource :sub_tasks do
                desc 'Return list of sub-tasks for a task'
                get do
                    sub_tasks = SubTask.where(task_id: params[:task_id])
                    present sub_tasks
                end
        
                desc 'Create a sub-task for a task'
                params do
                    requires :sub_task_name, type: String, desc: 'Sub-task name'
                    requires :status, type: String, desc: 'Status'
                    requires :due_date, type: DateTime, desc: 'Due date'
                end
                post do
                    task = Task.find(params[:task_id])
                    sub_task = task.sub_tasks.new(
                        sub_task_name: params[:sub_task_name],
                        status: params[:status],
                        due_date: params[:due_date],
                        created_user_id: Current.user.id
                        )
                    if sub_task.save
                        present sub_task
                    else
                        error!(sub_task.errors.full_messages, 422)
                    end
                end
        
                route_param :id do
                    desc 'Return a sub-task by ID'
                    get do
                        sub_task = SubTask.find(params[:id])
                        present sub_task
                    end
    
                    desc 'Update a sub-task'
                    params do
                        optional :sub_task_name, type: String, desc: 'Sub-task name'
                        optional :status, type: String, desc: 'Status'
                        optional :due_date, type: DateTime, desc: 'Due date'
                    end
                    put do
                        sub_task = SubTask.find(params[:id])
                        user_task = UserTask.find_by(task_id: sub_task.task_id, assigned_to: Current.user.id)
                        unless sub_task.created_user_id == Current.user.id || user_task.present? || Current.user.admin?
                            error!('You are not authorized to do this action.', 403)
                        end
                        sub_task.update!(declared(params, include_missing: false))
                        present sub_task
                    end
        
                    desc 'Delete a sub-task'
                    delete do
                        sub_task = SubTask.find(params[:id])
                        unless sub_task.created_user_id == Current.user.id || Current.user.admin?
                            error!('You are not authorized to do this action.', 403)
                        end
                        sub_task.destroy
                        { message: 'Sub-task deleted successfully' }
                    end
                end
            end
        end
    end
end