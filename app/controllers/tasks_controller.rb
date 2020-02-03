class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :authenticate_user

  def index
    if params[:user_id]
      @tasks = Task.seen_by_admin(params[:user_id], params[:page])
      @flag = true
    else
      @tasks = current_user.tasks.page10(params[:page])
    end

    if params[:sort_deadline]
      @tasks = @tasks.order(:deadline)
    elsif params[:sort_priority]
      @tasks = @tasks.order(priority: :DESC)
    else
      @tasks = @tasks.order(created_at: :DESC)
    end

    if params[:task]
      title = params[:task][:title_search]
      status = params[:task][:status_search]
      label_id = params[:task][:label_id]
      @tasks = @tasks.search_result(title, status, label_id, params[:page])
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
      label_ids: [],
    )
  end

end
