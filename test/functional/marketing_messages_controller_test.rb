require 'test_helper'

class MarketingMessagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:marketing_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create marketing_message" do
    assert_difference('MarketingMessage.count') do
      post :create, :marketing_message => { }
    end

    assert_redirected_to marketing_message_path(assigns(:marketing_message))
  end

  test "should show marketing_message" do
    get :show, :id => marketing_messages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => marketing_messages(:one).to_param
    assert_response :success
  end

  test "should update marketing_message" do
    put :update, :id => marketing_messages(:one).to_param, :marketing_message => { }
    assert_redirected_to marketing_message_path(assigns(:marketing_message))
  end

  test "should destroy marketing_message" do
    assert_difference('MarketingMessage.count', -1) do
      delete :destroy, :id => marketing_messages(:one).to_param
    end

    assert_redirected_to marketing_messages_path
  end
end
