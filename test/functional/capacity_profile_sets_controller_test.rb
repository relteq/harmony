require File.expand_path('../../test_helper', __FILE__)

class CapacityProfileSetsControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do
      @project = Project.generate!
      @capacity_profile_set = CapacityProfileSet.generate!
      @project.capacity_profile_sets << @capacity_profile_set
      @network = @capacity_profile_set.network
      @project.networks << @network
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 1
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @cprofilesets" do
          assert_equal @project.capacity_profile_sets, assigns(:cprofilesets)
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

        should "assign @cpset" do
          assert_not_nil assigns(:cpset)
        end
      end
    end

    context "get edit" do
      context "with valid params" do
        setup do
          get :edit, :project_id => @project, :id => @capacity_profile_set.id 
        end

        should "respond with success" do
          assert_response :success
        end

        should "assign @cpset" do
          assert_equal @capacity_profile_set, assigns(:cpset)
        end
      end

      context "with invalid capacity profile set" do
        setup do
          get :edit, :project_id => @project, :id => -1
        end

        should "redirect to capacity_profile_sets index" do
          assert_redirected_to :controller => 'capacity_profile_sets',
                               :action => 'index',
                               :project_id => assigns(:project)
        end
      end
    end

    context "post create" do
      should "increase capacity profile set count by 1, redirect to edit" do
        assert_difference('CapacityProfileSet.count') do
          post :create, :project_id => @project, 
               :capacity_profile_set => { :network_id => @network, :name => 'test'}
        end

        assert_redirected_to :controller => 'capacity_profile_sets',
                             :action => 'edit',
                             :project_id => assigns(:project),
                             :id => assigns(:cpset).id
      end
    end

    context "put update" do
      setup do 
        put :update, :project_id => @project,
            :id => @capacity_profile_set.id,
            :capacity_profile_set => { :name => 'foobar' }
      end

      should "update capacity profile" do
        assert_equal 'foobar', assigns(:cpset).name
      end
      
      should "redirect to edit" do
        assert_redirected_to :controller => 'capacity_profile_sets',
                             :action => 'edit',
                             :project_id => @project,
                             :id => @capacity_profile_set.id
      end
    end

    context "delete destroy" do
      should "reduce capacity profile set count by 1, redirect to index" do
        assert_difference('CapacityProfileSet.count', -1) do
          delete :destroy, :project_id => @project, 
                 :id => @capacity_profile_set.to_param
        end

        assert_redirected_to :controller => 'capacity_profile_sets', 
                             :action => 'index', 
                             :project_id => @project 
      end
    end

    context "post delete_all" do
      setup { post :delete_all, :project_id => @project }

      should "reduce capacity profile set count to 0" do
        assert_equal @project.capacity_profile_sets.count, 0 
      end

      should "redirect to index" do
        assert_redirected_to :controller => 'capacity_profile_sets', 
                             :action => 'index', 
                             :project_id => @project 
      end
    end
  end

  context "with unauthorized user" do
    setup do
      @project = Project.generate!
      @capacity_profile_set = CapacityProfileSet.generate!
      @project.capacity_profile_sets << @capacity_profile_set
      @network = @capacity_profile_set.network
      @project.networks << @network
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 7
    end

    context "all actions" do
      should "return forbidden" do
        get :new, :project_id => @project 
        assert_response 403 
        
        get :edit, :project_id => @project, :id => @capacity_profile_set.id
        assert_response 403 

        post :create, :project_id => @project, :capacity_profile_set => {:name => 'unique'}
        assert_response 403 

        put :update, :project_id => @project,
            :id => @capacity_profile_set.to_param,
            :network => { :name => 'foobar' }
        assert_response 403 

        delete :destroy, :project_id => @project, 
               :id => @capacity_profile_set.to_param
        assert_response 403 

        post :delete_all, :project_id => @project
        assert_response 403 
      end
    end
  end
end
