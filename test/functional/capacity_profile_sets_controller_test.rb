require File.expand_path('../../test_helper', __FILE__)

class CapacityProfileSetsControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @capacity_profile_set = CapacityProfileSet.generate!
      @network = @capacity_profile_set.network
      @project.networks << @network
      @request.session[:user_id] = 1
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @cpsets" do
          assert_not_nil assigns(:cpsets)
          assert_equal @project.capacity_profile_sets, assigns(:cpsets)
        end
      end

      context "with invalid project ID" do
        setup { get :index, :project_id => -1 }

        should "redirect to 404" do
          assert_response 404
        end
      end
    end
  end
end
