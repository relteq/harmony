require File.expand_path('../../test_helper', __FILE__)

class SimulationBatchControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @project = Project.generate!
    end

    context "get index" do
      context "with valid params" do
        setup { get :index, :project_id => @project }

        should "respond with success" do
          assert_response :success
        end

        should "assign @items_show" do
          assert_not_nil assigns(:items_show)
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
