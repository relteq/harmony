require File.expand_path('../../test_helper', __FILE__)

class NetworksControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @network = Network.generate! 
      @project.networks << @network
      @request.session[:user_id] = 1
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @networks" do
          assert_not_nil assigns(:networks)
          assert_equal @project.networks, assigns(:networks)
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

        should "assign @network" do
          assert_not_nil assigns(:network)
        end
      end
    end

    context "get edit" do
      context "with valid params" do
        setup do
          get :edit, :project_id => @project, :id => @network.id 
        end

        should "respond with success" do
          assert_response :success
        end

        should "assign @network" do
          assert_equal @network, assigns(:network)
        end
      end

      context "with invalid network" do
        setup do
          get :edit, :project_id => @project, :id => -1
        end

        should "redirect to networks index" do
          assert_redirected_to :controller => 'networks',
                               :action => 'index',
                               :project_id => assigns(:project)
        end
      end
    end

    context "post create" do
      should "increase network count by 1, redirect to edit" do
        assert_difference('Network.count') do
          post :create, :project_id => @project, 
               :network => { :name => 'unique'}
        end

        assert_redirected_to :controller => 'networks',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :id => assigns(:network).id
      end
    end

    context "put update" do
      setup do 
        put :update, :project_id => @project,
            :id => @network.id,
            :network => { :name => 'foobar' }
      end

      should "update network" do
        assert_equal 'foobar', assigns(:network).name
      end
      
      should "redirect to edit" do
        assert_redirected_to :controller => 'networks',
                             :action => 'edit',
                             :project_id => @project,
                             :id => @network.id
      end
    end

    context "delete destroy" do
      should "reduce network count by 1, redirect to index" do
        assert_difference('Network.count', -1) do
          delete :destroy, :project_id => @project, 
                 :id => @network.to_param
        end

        assert_redirected_to :controller => 'networks', 
                             :action => 'index', 
                             :project_id => @project 
      end
    end

    context "post delete_all" do
      setup { post :delete_all, :project_id => @project }

      should "reduce network count to 0" do
        assert_equal @project.networks.count, 0 
      end

      should "redirect to index" do
        assert_redirected_to :controller => 'networks', 
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
      @network = Network.generate! 
      @project.networks << @network
    end

    context "all actions" do
      should "return forbidden" do
        get :new, :project_id => @project 
        assert_response 403 
        
        get :edit, :project_id => @project, :id => @network.id
        assert_response 403 

        post :create, :project_id => @project, :network => {:name => 'unique'}
        assert_response 403 

        put :update, :project_id => @project,
            :id => @network.to_param,
            :network => { :name => 'foobar' }
        assert_response 403 

        delete :destroy, :project_id => @project, 
               :id => @network.to_param
        assert_response 403 

        post :delete_all, :project_id => @project
        assert_response 403 
      end
    end
  end

end
