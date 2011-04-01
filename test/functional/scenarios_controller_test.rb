require File.expand_path('../../test_helper', __FILE__)

class ScenariosControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @scenario = Scenario.generate!
      @network = @scenario.network
      @project.scenarios << @scenario
      @request.session[:user_id] = 1
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @scenarios" do
          assert_not_nil assigns(:scenarios)
          assert_equal assigns(:scenarios), @project.scenarios
        end
      end

      context "with invalid project ID" do
        setup { get :index, :project_id => -1 }

        should "redirect to 404" do
          assert_response 404
        end
      end
    end

    context "get new" do
      setup { get :new, :project_id => @project }

      context "with valid params" do
        should "respond with success" do
          assert_response :success
        end

        should "assign @scenario" do
          assert_not_nil assigns(:scenario)
        end
      end
    end

    context "get edit" do
      context "with valid params" do
        setup do
          get :edit, :project_id => @project, :scenario_id => @scenario.id 
        end

        should "respond with success" do
          assert_response :success
        end

        should "assign @scenario" do
          assert_equal @scenario, assigns(:scenario)
        end
      end

      context "with invalid scenario" do
        setup do
          get :edit, :project_id => @project, :scenario_id => -1
        end

        should "redirect to scenario index" do
          assert_redirected_to :controller => 'scenarios',
                               :action => 'index',
                               :project_id => assigns(:project)
        end
      end
    end

    context "post create" do
      should "increase scenario count by 1, redirect to edit" do
        assert_difference('Scenario.count') do
          post :create, :project_id => @project, :scenario => { :name => 'unique', 
            :network_id => @network.id }
        end

        assert_redirected_to :controller => 'scenarios',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :scenario_id => assigns(:scenario).id
      end
    end

    context "put update" do
      setup do 
        put :update, :project_id => @project,
            :scenario_id => @scenario.id,
            :scenario => { :name => 'foobar' }
      end

      should "update scenario" do
        assert_equal 'foobar', assigns(:scenario).name
      end
      
      should "redirect to edit" do
        assert_redirected_to :controller => 'scenarios',
                             :action => 'edit',
                             :project_id => @project,
                             :scenario_id => @scenario.id
      end
    end

    context "delete destroy" do
      should "reduce scenario count by 1, redirect to index" do
        assert_difference('Scenario.count', -1) do
          delete :destroy, :project_id => @project, 
                 :scenario_id => @scenario.to_param
        end

        assert_redirected_to :controller => 'scenarios', 
                             :action => 'index', 
                             :project_id => @project 
      end
    end

    context "post delete_all" do
      setup { post :delete_all, :project_id => @project }

      should "reduce scenario count to 0" do
        assert_equal @project.scenarios.count, 0 
      end

      should "redirect to index" do
        assert_redirected_to :controller => 'scenarios', 
                             :action => 'index', 
                             :project_id => @project 
      end
    end
  end

  context "with unauthorized user" do
    setup do
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 7
      @project = Project.generate!
      @scenario = Scenario.generate!
      @network = @scenario.network
      @project.scenarios << @scenario
    end

    context "all actions" do
      should "return forbidden" do
        get :new, :project_id => @project 
        assert_response 403 
        
        get :edit, :project_id => @project, :scenario_id => @scenario.to_param
        assert_response 403 

        post :create, :project_id => @project, :scenario => { :name => 'unique', 
            :network_id => @network.id }
        assert_response 403 

        put :update, :project_id => @project,
            :scenario_id => @scenario.to_param,
            :scenario => { :name => 'foobar' }
        assert_response 403 

        delete :destroy, :project_id => @project, 
               :scenario_id => @scenario.to_param
        assert_response 403 

        post :delete_all, :project_id => @project
        assert_response 403 
      end
    end
  end
end
