class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  add_breadcrumb I18n.t('home'), :root_path
  
  def login
  end
  
  def authenticate
    username = params[:person][:username]
    ldap_info = true#Ldap.auth(username, params[:person][:password])
    
    respond_to do |format|
      if ldap_info
        user = User.find_by_username(username)
        if not user
            attrs = Ldap.attributes(username)
            puts attrs[:cn]
            user = User.new :username => username
            user.name = attrs[:cn].to_s.delete("\"").delete("[").delete("]")
            user.save
        end
        
        if user.blocked_until == nil || user.blocked_until < Time.now
        
            session[:user_id] = user.id
            session[:username] = username
            
            format.html { redirect_to :back, notice: I18n.t('login_success') }
            format.json { render json: @ad, status: :created, location: @ad }
        else
            format.html { redirect_to :back, notice: I18n.t('user.blocked') }
            format.json { render json: @ad.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to :back, notice: I18n.t('login_failure') }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # logout
  # clears the session
  def logout
    session[:user_id] = nil
    session[:username] = nil
    
    respond_to do |format|
      format.html { redirect_to :back, notice: I18n.t('logout_success') }
      format.json { render json: @ad, status: :logged_out }
    end
  end

  def auto_complete
    @users = User.find(:all, :conditions => ['name LIKE ?', "#{params[:term]}%"])
    @labels = []
    @users.each do |u|
      @labels << {:value => u.username, :label => u.name}
    end
    
    respond_to do |format|
      format.json { render json: @labels.to_json }
    end
  end
  
  def ads
    add_breadcrumb I18n.t('user.ads'), :ads_users_path
    
    @user = User.find_by_id(session[:user_id])
    respond_to do |format|
      if @user
        @ads = @user.ads.page(params[:page])
        format.html
      else
        format.html { redirect_to root_path, notice: I18n.t(:access_denied) }
      end
    end
  end
  
  def favorites
    add_breadcrumb I18n.t('user.favorites'), :favorites_users_path
    
    @user = User.find_by_id(session[:user_id])
    respond_to do |format|
      if @user
        @ads = @user.favorite_ads.page(params[:page])
        format.html
      else
        format.html { redirect_to root_path, notice: I18n.t(:access_denied) }
      end
    end
  end
  
end
