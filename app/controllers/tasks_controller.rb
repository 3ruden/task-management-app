class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :authenticate_user

  def index
    if params[:user_id]
      @tasks = Task.where(user_id: params[:user_id]).includes(:user).page(params[:page]).per(5)
      @flag = true
    else
      @tasks = current_user.tasks.all.page(params[:page]).per(5)
    end

    if params[:sort_deadline]
      @tasks = @tasks.order(:deadline)
    elsif params[:sort_priority]
      @tasks = @tasks.order(priority: :DESC)
    else
      @tasks = @tasks.order(created_at: :DESC)
    end

    if params[:task]
      title_search = params[:task][:title_search]
      status_search = params[:task][:status_search]
      @tasks = @tasks.get_search_result(title_search, status_search)
    end

  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: 'タスクを作成しました'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクを編集しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'タスクを削除しました'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :deadline,
      :status,
      :priority,
    )
  end

end
