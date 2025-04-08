require_relative "../utils/uuidv7"

class TaskService

  def initialize(params)
    @params = params
  end

  def add(remind_at)
    Task.create(
      task_content: @params[:task_content],
      task_remind_at: remind_at,
      task_title: @params[:task_title],
      task_uid: uuidv7,
    )
  end

end
