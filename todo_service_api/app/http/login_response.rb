class LoginResponse
  def initialize(username, full_name, user_uid, token)
    @username = username
    @full_name = full_name
    @user_uid = user_uid
    @token = token
  end

  def username
    @username
  end

  def full_name
    @full_name
  end

  def user_uid
    @user_uid
  end

  def token
    @token
  end

end