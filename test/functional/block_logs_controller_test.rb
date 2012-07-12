require 'test_helper'

class BlockLogsControllerTest < ActionController::TestCase
=begin
  setup do
    @block_log = block_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:block_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create block_log" do
    assert_difference('BlockLog.count') do
      post :create, block_log: @block_log.attributes
    end

    assert_redirected_to block_log_path(assigns(:block_log))
  end

  test "should show block_log" do
    get :show, id: @block_log.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @block_log.to_param
    assert_response :success
  end

  test "should update block_log" do
    put :update, id: @block_log.to_param, block_log: @block_log.attributes
    assert_redirected_to block_log_path(assigns(:block_log))
  end

  test "should destroy block_log" do
    assert_difference('BlockLog.count', -1) do
      delete :destroy, id: @block_log.to_param
    end

    assert_redirected_to block_logs_path
  end
=end
end
