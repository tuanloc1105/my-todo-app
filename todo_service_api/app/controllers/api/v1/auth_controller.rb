require_relative '../../../utils/uuidv7'
require_relative '../../../service/user_service'

class Api::V1::AuthController < ApplicationController

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

  def user_params
    params.permit(:username, :password, :full_name)
  end

end
