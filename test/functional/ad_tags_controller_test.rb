require 'test_helper'

class AdTagsControllerTest < ActionController::TestCase
=begin
  setup do
    @ad_tag = ad_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ad_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ad_tag" do
    assert_difference('AdTag.count') do
      post :create, ad_tag: @ad_tag.attributes
    end

    assert_redirected_to ad_tag_path(assigns(:ad_tag))
  end

  test "should show ad_tag" do
    get :show, id: @ad_tag.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ad_tag.to_param
    assert_response :success
  end

  test "should update ad_tag" do
    put :update, id: @ad_tag.to_param, ad_tag: @ad_tag.attributes
    assert_redirected_to ad_tag_path(assigns(:ad_tag))
  end

  test "should destroy ad_tag" do
    assert_difference('AdTag.count', -1) do
      delete :destroy, id: @ad_tag.to_param
    end

    assert_redirected_to ad_tags_path
  end
=end
end
