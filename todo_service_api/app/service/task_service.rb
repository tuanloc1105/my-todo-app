require "common_lib"

class TaskService
  include CommonLib

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def list_all_tasks
    Task.where(created_by: @current_user.username)
  end

  def task_info
    Task.where(created_by: @current_user.username).and(Task.where(task_uid: @params[:task_uid])).first
  end

  def search_task_by_name
    Task.where(created_by: @current_user.username).and(Task.where("task_title LIKE ?", @params[:task_title]))
  end

  def update_task_info
    task = task_info
    if task.nil?
      return [
        404,
        {
          code: -404,
          error: "Cannot find task with uid #{@params[:task_uid]}"
        }
      ]
    end
    task_update_result = task.update(
      task_uid: @params[:task_uid],
      task_content: @params[:task_content],
      task_remind_at: @params[:task_remind_at],
      task_title: @params[:task_title],
    )
    if task_update_result
      return [
        200,
        {
          message: "update ok"
        }
      ]
    else
      return [
        500,
        {
          message: "update error"
        }
      ]
    end
  end

  def delete_task
    task = task_info
    if task.nil?
      return [
        404,
        {
          code: -404,
          error: "Cannot find task with uid #{@params[:task_uid]}"
        }
      ]
    end
    task.destroy
    return [
      200,
      {
        message: "delete ok"
      }
    ]
  end

  def add(remind_at)
    Task.create(
      task_content: @params[:task_content],
      task_remind_at: remind_at,
      task_title: @params[:task_title],
      task_uid: uuidv7,
      created_by: @current_user.username,
      updated_by: @current_user.username,
    )
  end

end
