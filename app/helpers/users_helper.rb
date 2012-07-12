module UsersHelper
  def admin?
    return false unless session[:user_id]
    user = User.find(session[:user_id])
    return user.admin
  end
end
