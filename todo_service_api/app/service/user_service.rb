require_relative "../utils/uuidv7"
require "bcrypt"

class UserService
  include BCrypt

  def initialize(params)
    @params = params
  end

  def user_existed_by_username
    User.exists?(username: @params[:username])
  end

  def login
    user = User.where(username: @params[:username]).first
    if user.nil?
      raise UserNotExistError.new("User with username #{@params[:username]} not found")
    end

    if Password.new(user.password) == @params[:password]
      hmac_secret = ENV["TOKEN_SECRET"]
      payload = {
        username: user.username,
        full_name: user.full_name,
        user_uid: user.user_uid,
      }
      LoginResponse.new(
        user.username,
        user.full_name,
        user.user_uid,
        JWT.encode(payload, hmac_secret, "HS256")
      )
    else
      LoginResponse.new(
        nil,
        nil,
        nil,
        nil,
      )
    end

  end

  def create_new
    User.create(
      full_name: @params[:full_name],
      username: @params[:username],
      password: Password.create(@params[:password]),
      user_uid: uuidv7,
      active: true
    )
  end

end
