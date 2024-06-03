class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :authorize_admin!, only: [:assign]

  def index
    if Current.user.admin?
      @tasks = Task.all
    else
      @tasks = Current.user.tasks + Task.joins(:assignments).where(assignments: { assigned_to_id: Current.user.id })
      @tasks.uniq!
    end
  end

  def show
    if Current.user.admin?
      @user_tasks = @task.user_tasks
    else
      @user_tasks = @task.user_tasks.find_by(user_id: Current.user.id)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Current.user.tasks.new(task_params)
    if @task.save
      if params[:task][:assigned_user_ids].present?
        params[:task][:assigned_user_ids].each do |user_id|
          Assignment.create(task: @task, assigned_to_id: user_id, assigned_by_id: Current.user.id)
        end
      end
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user_task = @task.user_tasks.find_by(user: Current.user)
  end

  def update
    if @task.update(task_params)
      user_task = @task.user_tasks.find_or_initialize_by(user_id: Current.user.id)
      user_task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.user_tasks.destroy_all
    @task.assignments.destroy_all
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully deleted.'
  end

  def assign
    @users = User.where.not(id: Current.user.id)
    already_assigned_user_ids = @task.assignments.pluck(:assigned_to_id)
    @available_users = @users.where.not(id: already_assigned_user_ids)

    if request.post?
      assignee_id = params[:task][:assignee_id]
      assignee = User.find_by(id: assignee_id)
      if assignee
        assignment = Assignment.new(task: @task, assigned_to: assignee, assigned_by: Current.user)
        if assignment.save
          redirect_to tasks_path, notice: 'Task was successfully assigned.'
        else
          redirect_to tasks_path, alert: 'Failed to assign task.'
        end
      else
        redirect_to tasks_path, alert: 'Invalid assignee ID.'
      end
    else
      @users = User.all
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :status, :due_date, :priority_level, assigned_user_ids: [])
  end

  def authenticate_user!
    redirect_to login_path, alert: 'You must be logged in to access this section' unless Current.user
  end

  def authorize_user!
    assigned_to_current_user = @task.assignments.exists?(assigned_to: Current.user)
    unless Current.user == @task.user || Current.user.role == 'admin' || assigned_to_current_user
      redirect_to tasks_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_admin!
    redirect_to tasks_path, alert: 'You are not authorized to perform this action.' unless Current.user.admin?
  end
end
