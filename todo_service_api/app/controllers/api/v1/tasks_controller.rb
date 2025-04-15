class Api::V1::TasksController < ApplicationController

  wrap_parameters false
  before_action :authenticate, only: [ :add, :list_all_tasks, :task_info, :update_task_info, :delete_task, :search_task ]

  def add
    required_fields = %w[task_content task_remind_at task_title]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      render json: {
        code: -5,
        error: "[#{missing_fields.join(', ')}] cannot be empty"
      }, status: :not_acceptable
      return
    end
    begin
      parsed_task_remind_at = Time.strptime(params[:task_remind_at].to_s, "%Y-%m-%d %H:%M:%S.%L")
    rescue ArgumentError => e
      render json: {
        code: -5,
        error: "Can not parse a valid date for task_remind_at: #{e}"
      }, status: :bad_request
      return
    end
    service = TaskService.new(add_task_params, @current_user)
    render json: service.add(parsed_task_remind_at)
  end

  def list_all_tasks
    service = TaskService.new(nil, @current_user)
    tasks_of_current_user = service.list_all_tasks
    render json: {
      tasks: tasks_of_current_user
    }
  end

  def task_info
    required_fields = %w[task_uid]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      render json: {
        code: -5,
        error: "[#{missing_fields.join(', ')}] cannot be empty"
      }, status: :not_acceptable
      return
    end
    service = TaskService.new(task_info_param, @current_user)
    task_info = service.task_info
    if task_info.nil?
      render json: {
        code: -404,
        error: "Cannot find task with uid #{task_info_param[:task_uid]}"
      }, status: :not_found
      return
    end
    render json: service.task_info
  end

  def update_task_info
    required_fields = %w[task_uid task_content task_remind_at task_title]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      render json: {
        code: -5,
        error: "[#{missing_fields.join(', ')}] cannot be empty"
      }, status: :not_acceptable
      return
    end
    service = TaskService.new(update_task_info_param, @current_user)
    result = service.update_task_info
    render json: result[1], status: result[0]
  end

  def delete_task
    service = TaskService.new(task_info_param, @current_user)
    result = service.delete_task
    render json: result[1], status: result[0]
  end

  def search_task
    service = TaskService.new(search_task_param, @current_user)
    render json: {
      result: service.search_task_by_name
    }
  end

  def authenticate
    token = request.headers["Authorization"].to_s
    if token.nil? or token.empty?
      render json: {
        error: "Invalid token"
      }
    end
    substr = token[7..-1]
    if substr.nil? or substr.empty?
      render json: {
        error: "Invalid token"
      }
      return
    end
    begin
      hmac_secret = ENV["TOKEN_SECRET"]
      decoded_content = JWT.decode(substr, hmac_secret, "HS256")
      puts "Current user is #{decoded_content[0]["username"]}"
      @current_user = User.find_by(username: decoded_content[0]["username"])
    rescue => e
      Rails.logger.info e
      render json: {
        error: "Validate token failed"
      }
    end
  end

  def add_task_params
    params.permit(:task_content, :task_remind_at, :task_title)
  end

  def task_info_param
    params.permit(:task_uid)
  end

  def update_task_info_param
    params.permit(:task_uid, :task_content, :task_remind_at, :task_title)
  end

  def search_task_param
    params.permit(:task_title)
  end

end
