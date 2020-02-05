module TasksHelper
  def sort_deadline_params
  merged_params = params.permit(
    :title_search,
    :status_search,
    :label_id,
    :sort_deadline
  ).merge(sort_deadline: true)
  end

  def sort_priority_params
  merged_params = params.permit(
    :title_search,
    :status_search,
    :label_id,
    :sort_priority
  ).merge(sort_priority: true)
  end
end
