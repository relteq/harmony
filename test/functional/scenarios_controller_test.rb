require File.expand_path('../../test_helper', __FILE__)

class ScenariosControllerTest < ActionController::TestCase
  fixtures :scenarios, :projects, :users, :roles

  def setup
    @request = ActionController::TestRequest.new
    # FIXME ScenariosController is only being tested with valid users with permission to view,
    # edit, and delete scenarios.
    @request.session[:user_id] = 1
  end

  test "scenario index should respond with success and assign @scenarios" do
    get :index, :project_id => 1
    assert_response :success
    assert_not_nil assigns(:scenarios)
  end

  test "new scenario should respond with success and assign @scenario" do
    get :new, :project_id => 1
    assert_response :success
    assert_not_nil assigns(:scenario)
  end

  test "create scenario with valid params should increase scenario count by 1 and redirect to edit" do
    assert_difference('Scenario.count') do
      post :create, :project_id => 1, :scenario => { :name => 'unique' }
    end

    assert_redirected_to :controller => 'scenarios',
                         :action => 'edit',
                         :project_id => assigns(:project),
                         :scenario_id => assigns(:scenario).id
  end

  test "show scenario with valid params should respond with success" do
    get :show, :project_id => 1, :id => scenarios(:one).to_param
    assert_response :success
  end

  test "edit scenario with valid params should respond with success" do
    get :edit, :project_id => 1, :scenario_id => scenarios(:one).to_param
    assert_response :success
  end

  test "update scenario should redirect to edit scenario" do
    put :update, :project_id => 1, :scenario_id => scenarios(:one).to_param, :scenario => { }
    assert_redirected_to :controller => 'scenarios',
                         :action => 'edit',
                         :project_id => projects(:projects_001),
                         :scenario_id => scenarios(:one).id
  end

  test "destroy scenario with valid params should reduce scenario count by 1, redirect to index" do
    assert_difference('Scenario.count', -1) do
      delete :destroy, :project_id => 1, :scenario_id => scenarios(:one).to_param
    end

    assert_redirected_to :controller => 'scenarios', :action => 'index', :project_id => assigns(:project) 
  end
end
