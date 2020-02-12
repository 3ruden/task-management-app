class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :authenticate_user
  before_action :ensure_correct_user, only: %i(edit update destroy)

  def index
    if params[:user_id]
      @tasks = Task.seen_by_admin(params[:user_id], params[:page])
      @flag = true
    else
      @tasks = current_user.tasks.page10(params[:page])
    end

    @around_deadline_tasks = @tasks.around_deadline

    if params[:sort_deadline]
      @tasks = @tasks.order(:deadline)
    elsif params[:sort_priority]
      @tasks = @tasks.order(priority: :DESC)
    else
      @tasks = @tasks.order(created_at: :DESC)
    end

    title = params[:title_search]
    status = params[:status_search]
    label_id = params[:label_id]
    @tasks = @tasks.search_result(title, status, label_id, params[:page])
  end

  def show
    Read.create(task_id: @task.id, user_id: current_user.id) if Read.where(task_id: @task.id).find_by(user_id: current_user.id).blank?
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

  def ensure_correct_user
    @task = Task.find(params[:id])
    redirect_to root_url unless @task.user_id == current_user.id
  end

end
