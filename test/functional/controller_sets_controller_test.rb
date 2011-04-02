require File.expand_path('../../test_helper', __FILE__)
require 'test/exemplars/controller_set'

class ControllerSetsControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @network = Network.generate!
      @controller_set = ControllerSet.generate!
      @project.controller_sets << @controller_set
      @request.session[:user_id] = 1
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @controller_sets" do
          assert_equal @project.controller_sets, assigns(:csets)
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

        should "assign @cset" do
          assert_not_nil assigns(:cset)
        end
      end
    end

    context "get edit" do
      context "with valid params" do
        setup do
          get :edit, :project_id => @project, :id => @controller_set.id 
        end

        should "respond with success" do
          assert_response :success
        end

        should "assign @cset" do
          assert_equal @controller_set, assigns(:cset)
        end
      end

      context "with invalid controller set ID" do
        setup do
          get :edit, :project_id => @project, :id => -1
        end

        should "redirect to controller set index" do
          assert_redirected_to :controller => 'controller_sets',
                               :action => 'index',
                               :project_id => assigns(:project)
        end
      end
    end

    context "post create" do
      should "increase controller set count by 1, redirect to edit" do
        assert_difference('ControllerSet.count') do
          post :create, :project_id => @project, :controller_set => { :name => 'unique', 
            :network_id => @network.id }
        end

        assert_redirected_to :controller => 'controller_sets',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :id => assigns(:cset).id
      end
    end

    context "put update" do
      setup do 
        put :update, :project_id => @project,
            :id => @controller_set.id,
            :controller_set => { :name => 'foobar' }
      end

      should "update controller set" do
        assert_equal 'foobar', assigns(:cset).name
      end
      
      should "redirect to edit" do
        assert_redirected_to :controller => 'controller_sets',
                             :action => 'edit',
                             :project_id => @project,
                             :id => @controller_set.id
      end
    end

    context "delete destroy" do
      should "reduce controller set count by 1, redirect to index" do
        assert_difference('ControllerSet.count', -1) do
          delete :destroy, :project_id => @project, 
                 :id => @controller_set.to_param
        end

        assert_redirected_to :controller => 'controller_sets', 
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
        assert_redirected_to :controller => 'controller_sets', 
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
