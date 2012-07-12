class AdminController < ApplicationController  
  
  before_filter :authorize_admin
  
  add_breadcrumb I18n.t('home'), :root_path
  add_breadcrumb I18n.t('admin.link'), :admin_path
  
  
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def reported_comments
    add_breadcrumb I18n.t('admin.reported_comments'), url_for({ :action => 'reported_comments' })
    
    @comments = Comment.all_reported
    respond_to do |format|
      format.html # reported_comments.html.erb
    end
  end
  
  def users
    add_breadcrumb I18n.t('admin.list_users'), url_for({ :action => 'users' })
    
    @search_terms = params[:search_terms]
    @users = User.search_text(@search_terms, params[:page])
    respond_to do |format|
      format.html # users.html.erb
    end
  end

  def update_search
    @search_terms = params[:search_terms]
    @users = User.search_text(@search_terms, params[:page])
    
    respond_to do |format|
      format.js
    end
  end
  
  def authorize_admin
    unless admin?
      redirect_to dashboard_ads_path, notice: I18n.t('access_denied')
      false
    end
  end
  
  def admin?
    return false unless session[:user_id]
    user = User.find(session[:user_id])
    return user.admin
  end
  
  def promote_user
    @user = User.find(params[:user_id])
    if @user.make_admin!
      @notice = I18n.t 'admin.success_promote_user', :user => @user.username
    else
      @notice = I18n.t 'admin.unsuccess_promote_user', :user => @user.username
    end
    
    respond_to do |format|
        format.js
    end
  end
  
  def demote_user
    @user = User.find(params[:user_id])
    if @user.make_regular!
      @notice = I18n.t 'admin.success_demote_user', :user => @user.username
    else
      @notice = I18n.t 'admin.unsuccess_demote_user', :user => @user.username
    end
    
    respond_to do |format|
        format.js
    end
  end
  
  def block_user
    @user = User.find(params[:user_id])
    duration = params[:duration]
    
    if User.block!(@user.id, duration)
      @notice = I18n.t 'admin.success_block_user', :user => @user.username
    else
      @notice = I18n.t 'admin.unsuccess_block_user', :user => @user.username
    end    
    respond_to do |format|
        format.js
    end
  end
  
  def unblock_user
    @user = User.find(params[:user_id])
    duration = params[:duration]
    
    if User.unblock!(@user.id)
      @notice = I18n.t 'admin.success_unblock_user', :user => @user.username
    else
      @notice = I18n.t 'admin.unsuccess_unblock_user', :user => @user.username
    end    
    respond_to do |format|
        format.js
    end
  end
end
