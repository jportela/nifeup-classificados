require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  setup do
    @ad = ads(:a1)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ad" do
    assert_difference('Ad.count') do
      post :create, ad: @ad.attributes
    end

    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should show ad" do
    get :show, id: @ad.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ad.to_param
    assert_response :success
  end

  test "should update ad" do
    put :update, id: @ad.to_param, ad: @ad.attributes
    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should destroy ad" do
    assert_difference('Ad.count', -1) do
      delete :destroy, id: @ad.to_param
    end

    assert_redirected_to ads_path
  end
=end
end
