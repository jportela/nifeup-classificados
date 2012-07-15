module UsersHelper
  def admin?
    puts "DFDSFSDFSDFSDF\n\n\n"
    puts session.inspect
    return false unless session[:user_id]
    
    begin
        user = User.find(session[:user_id])
        rescue ActiveRecord::RecordNotFound
            return false
    end
    return user.admin
  end
end
