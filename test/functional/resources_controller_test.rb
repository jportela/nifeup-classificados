require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
=begin
  setup do
    @resource = resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post :create, resource: @resource.attributes
    end

    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should show resource" do
    get :show, id: @resource.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource.to_param
    assert_response :success
  end

  test "should update resource" do
    put :update, id: @resource.to_param, resource: @resource.attributes
    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should destroy resource" do
    assert_difference('Resource.count', -1) do
      delete :destroy, id: @resource.to_param
    end

    assert_redirected_to resources_path
  end
=end
end
