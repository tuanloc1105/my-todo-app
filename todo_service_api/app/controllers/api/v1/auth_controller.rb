require_relative '../../../utils/uuidv7'

class Api::V1::AuthController < ApplicationController

  def register
    full_name = params[:full_name]
    username = params[:username]
    password = params[:password]
    if User.exists?(username: username)
      render json: {
        code: -1,
        error: "User already exist"
      }, status: :not_acceptable
      return
    end

    new_user = User.create(
      full_name: full_name,
      username: username,
      password: password,
      user_uid: uuidv7,
      active: true
    )
    render json: new_user
  end

end
