require File.expand_path('../../test_helper', __FILE__)

class ScenariosControllerTest < ActionController::TestCase
  fixtures :scenarios, :projects, :users, :roles, :networks

  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 1
    end

    context "get index" do
      setup { get :index, :project_id => 1 }

      should "respond with success and assign @scenarios" do
        assert_response :success
      end

      should "assign @scenarios" do
        assert_not_nil assigns(:scenarios)
      end
    end

    context "get new" do
      setup { get :new, :project_id => 1 }

      should "respond with success" do
        assert_response :success
      end

      should "assign @scenario" do
        assert_not_nil assigns(:scenario)
      end
    end

    context "get edit" do
      setup do
        get :edit, :project_id => 1, :scenario_id => scenarios(:one).to_param
      end
    
      should "respond with success" do
        assert_response :success
      end

      should "assign @scenario" do
        assert_equal assigns(:scenario), scenarios(:one)
      end
    end

    context "post create" do
      should "increase scenario count by 1, redirect to edit" do
        assert_difference('Scenario.count') do
          post :create, :project_id => 1, :scenario => { :name => 'unique', 
            :network_id => networks(:one).id }
        end

        assert_redirected_to :controller => 'scenarios',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :scenario_id => assigns(:scenario).id
      end
    end

    context "put update" do
      setup do 
        put :update, :project_id => 1,
            :scenario_id => scenarios(:one).to_param,
            :scenario => { :name => 'foobar' }
      end

      should "update scenario" do
        assert_equal assigns(:scenario).name, 'foobar'
      end
      
      should "redirect to edit" do
        assert_redirected_to :controller => 'scenarios',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :scenario_id => scenarios(:one).id
      end
    end

    context "delete destroy" do
      should "reduce scenario count by 1, redirect to index" do
        assert_difference('Scenario.count', -1) do
          delete :destroy, :project_id => 1, 
                 :scenario_id => scenarios(:one).to_param
        end

        assert_redirected_to :controller => 'scenarios', 
                             :action => 'index', 
                             :project_id => assigns(:project) 
      end
    end
  end

  context "with unauthorized user" do
    setup do
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 7
    end

    context "all actions" do
      should "return forbidden" do
        get :new, :project_id => 1
        assert_response 403 
        
        get :edit, :project_id => 1, :scenario_id => scenarios(:one).to_param
        assert_response 403 

        post :create, :project_id => 1, :scenario => { :name => 'unique', 
            :network_id => networks(:one).id }
        assert_response 403 

        put :update, :project_id => 1,
            :scenario_id => scenarios(:one).to_param,
            :scenario => { :name => 'foobar' }
        assert_response 403 

        delete :destroy, :project_id => 1, 
               :scenario_id => scenarios(:one).to_param
        assert_response 403 
      end
    end
  end
end
