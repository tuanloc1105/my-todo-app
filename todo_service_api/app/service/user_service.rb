require_relative '../utils/uuidv7'
require 'bcrypt'

class UserService
  include BCrypt

  def initialize(params)
    @params = params
  end

  def user_existed_by_username
    User.exists?(username: @params[:username])
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
