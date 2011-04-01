require File.expand_path('../../test_helper', __FILE__)

class ConfigurationsControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 1
      @project = Project.generate!
    end

    context "get show" do
      setup { get :show, :project_id => @project }

      should "return success" do
        assert_response :success
      end
    end
  end

  context "with unauthorized user" do
    setup do 
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @request.session[:user_id] = 7
    end

    should "return forbidden" do
      get :show, :project_id => @project
      assert_response 403
    end
  end
end
