class Api::V1::TasksController < ApplicationController

  before_action :authenticate, only: [:add]

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
    rescue ArgumentError
      render json: {
        code: -5,
        error: "Can not parse a valid date for task_remind_at"
      }, status: :bad_request
      return
    end
    service = TaskService.new(add_task_params)
    render json: service.add(parsed_task_remind_at)
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
      puts decoded_content[0]
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

end
