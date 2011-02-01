require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scenarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scenario" do
    assert_difference('Scenario.count') do
      post :create, :scenario => { }
    end

    assert_redirected_to scenario_path(assigns(:scenario))
  end

  test "should show scenario" do
    get :show, :id => scenarios(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => scenarios(:one).to_param
    assert_response :success
  end

  test "should update scenario" do
    put :update, :id => scenarios(:one).to_param, :scenario => { }
    assert_redirected_to scenario_path(assigns(:scenario))
  end

  test "should destroy scenario" do
    assert_difference('Scenario.count', -1) do
      delete :destroy, :id => scenarios(:one).to_param
    end

    assert_redirected_to scenarios_path
  end
end
