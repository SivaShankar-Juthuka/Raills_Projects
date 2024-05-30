# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :authorize_admin!, only: [:assign]
  include TasksHelper

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Current.user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully completed.'
  end

  def assign
    if request.post?
      @assignee = User.find_by(id: params[:task][:assigned_to_id])

      if @assignee
        if @task.update(assigned_to_id: @assignee.id, assigned_by_id: Current.user.id)
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
    params.require(:task).permit(:task_name, :status, :due_date, :priority_level)
  end

  def authenticate_user!
    redirect_to login_path, alert: 'You must be logged in to access this section' unless Current.user
  end

  def authorize_user!
    unless Current.user == @task.user || Current.user.role == 'admin' || Current.user == @task.assigned_to
      redirect_to tasks_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_admin!
    redirect_to tasks_path, alert: 'You are not authorized to perform this action.' unless Current.user.admin?
  end
end
