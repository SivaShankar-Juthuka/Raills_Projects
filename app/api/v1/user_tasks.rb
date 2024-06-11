# app/api/v1/user_tasks.rb
class Api::V1::UserTasks < Grape::API
    before { authenticate! }
    before { authenticate! }

    resource :user_tasks do
      desc 'Return list of user tasks'
      params do
        optional :page, type: Integer, desc: 'Page number', default: 1
        optional :per_page, type: Integer, desc: 'Number of items per page', default: 5
      end
      get do
        user_tasks = paginate(UserTask.all)
        present user_tasks
      end

      desc 'Assign an existing task to a user (admin only)'
      params do
        requires :task_id, type: Integer, desc: 'Task ID'
        requires :assigned_to, type: Integer, desc: 'Assigned to user ID'
      end
      post do
        error!('You are not authorized to do this action.', 403) unless Current.user.admin?
        task = Task.find_by(id: params[:task_id])
        error!('Task not found', 404) unless task
        user_task = UserTask.new(
          task_id: task.id,
          assigned_to: params[:assigned_to],
          assigned_by: Current.user.id,
          status: task.status
        )
        if user_task.save
          present user_task
        else
          error!(user_task.errors.full_messages, 422)
        end
      end

      desc 'Return user tasks by task ID'
      params do
        requires :task_id, type: Integer, desc: 'Task ID'
      end
      get ':task_id' do
        user_tasks = UserTask.where(task_id: params[:task_id])
        if user_tasks.exists?
          present user_tasks
        else
          error!('Tasks not found', 404)
        end
      end

      desc 'Update a user task (user or admin)'
      params do
        requires :id, type: Integer, desc: 'User Task ID'
        optional :status, type: String, desc: 'Status'
      end
      put ':id' do
        user_task = UserTask.find(params[:id])
        if user_task.assigned_to == Current.user.id || Current.user.admin?
          user_task.update!(declared(params, include_missing: false))
          present user_task
        else
          error!('You are not authorized to do this action.', 403)
        end
      end

      desc 'Delete a user task (admin only)'
      params do
        requires :id, type: Integer, desc: 'User Task ID'
      end
      delete ':id' do
        error!('You are not authorized to do this action.', 403) unless Current.user.admin?
        user_task = UserTask.find(params[:id])
        user_task.destroy
        { message: 'User task deleted successfully' }
      end
    end
end
