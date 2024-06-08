# app/api/v1/user_tasks.rb
class Api::V1::UserTasks < Grape::API
    resource :user_tasks do
      before do
        authenticate!
      end
  
      desc 'Return list of user tasks'
      params do
        optional :page, type: Integer, desc: 'Page number', default: 1
        optional :per_page, type: Integer, desc: 'Number of items per page', default: 5
      end
      get do
        user_tasks = paginate(UserTask.all)
        present user_tasks
      end
  
      desc 'Assign a task to a user (admin only)'
      params do
        requires :task_id, type: Integer, desc: 'Task ID'
        requires :assigned_to, type: Integer, desc: 'Assigned to user ID'
      end
      post do
        error!('You are not authorized to do this action.', 403) unless Current.user.admin?
        task = Task.find(params[:task_id])
        error!('Task not found', 404) unless task
  
        user_task = UserTask.create!(
          task_id: task.id,
          task_name: task.task_name,
          status: task.status,
          due_date: task.due_date,
          assigned_to: params[:assigned_to],
          assigned_by: Current.user.id
        )
        present user_task
      end
  
      desc 'Return a user task'
      params do
        requires :id, type: Integer, desc: 'User Task ID'
      end
      get ':id' do
        user_task = UserTask.find_by(id: params[:id])
        if user_task.present?
          present user_task
        else
          error!('Task not found', 404)
        end
      end
  
      desc 'Update a user task (user or admin)'
      params do
        requires :id, type: Integer, desc: 'User Task ID'
        optional :status, type: String, desc: 'Status'
        optional :due_date, type: DateTime, desc: 'Due date'
      end
      put ':id' do
        user_task = UserTask.find(params[:id])
        task = user_task.task
  
        if user_task.assigned_to == Current.user.id || task.user_id == Current.user.id || Current.user.admin?
          user_task.update!(declared(params, include_missing: false))
          present user_task
        else
          error!('You are not authorized to do this action.', 403)
        end
      end
  
      desc 'Delete a user task (admin or creator)'
      params do
        requires :id, type: Integer, desc: 'User Task ID'
      end
      delete ':id' do
        user_task = UserTask.find(params[:id])
        task = user_task.task
  
        if task.user_id == Current.user.id || Current.user.admin?
          user_task.destroy
          { message: 'User task deleted successfully' }
        else
          error!('You are not authorized to do this action.', 403)
        end
      end
    end
end
  