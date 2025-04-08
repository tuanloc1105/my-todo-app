require_relative "../../../utils/uuidv7"
require_relative "../../../service/user_service"

class Api::V1::AuthController < ApplicationController

  before_action :authenticate, only: [ :info ]

  def register
    required_fields = %w[username password]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      render json: {
        code: -5,
        error: "[#{missing_fields.join(', ')}] cannot be empty"
      }, status: :not_acceptable
      return
    end
    service = UserService.new(user_params)
    if service.user_existed_by_username
      render json: {
        code: -1,
        error: "User already exist"
      }, status: :not_acceptable
      return
    end
    new_user = service.create_new
    render json: new_user.as_json(except: [:password])
  end

  def login
    required_fields = %w[username password]
    missing_fields = required_fields.select { |field| params[field].blank? }
    unless missing_fields.empty?
      render json: {
        code: -5,
        error: "[#{missing_fields.join(', ')}] cannot be empty"
      }, status: :not_acceptable
      return
    end
    service = UserService.new(user_params)
    begin
      result = service.login
      render json: result
    rescue UserNotExistError
      render json: {
        code: -1,
        error: "User not found"
      }, status: :not_found
    end
  end

  def info
    render json: {
      ok: true,
      ok2: {
        code: 0,
      }
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
      puts decoded_content[0]
    rescue => e
      Rails.logger.info e
      render json: {
        error: "Validate token failed"
      }
    end
  end

  def user_params
    params.permit(:username, :password, :full_name)
  end

end
