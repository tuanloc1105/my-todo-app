class LoginResponse
  def initialize(username, full_name, user_uid, token)
    @username = username
    @full_name = full_name
    @user_uid = user_uid
    @token = token
  end
end