class LabelsController < ApplicationController
  before_action :set_label, only: %i(edit update destroy)
  before_action :authenticate_user

  def index
    @label = Label.new
    @labels = Label.all
  end

  def create
    @label = Label.new(label_params)
    @labels = Label.all
    if @label.save
      redirect_to labels_url, notice: "ラベル「#{@label.name}」を作成しました"
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_url, notice: "ラベル「#{@label.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_url, notice: "ラベル「#{@label.name}」を削除しました"
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
