module TasksHelper
  def task_row_class(task)
    if task.closed?
      ''
    elsif task.closes_at < 2.hours.from_now
      'warning'
    else
      'active'
    end
  end
end
