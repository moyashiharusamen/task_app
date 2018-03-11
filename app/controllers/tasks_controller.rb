class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :authenticate_user, only: %i[index show edit update]

  def index
    @tasks = current_user.tasks.order_by(params[:column], params[:order])
                 .search_by_name(params[:search]).search_by_status(params[:status])
                 .page(params[:page]).includes(:user)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: 'タスクを作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクを修正しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'タスクを削除しました'
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :expires_at, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
