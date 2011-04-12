require File.expand_path('../../test_helper', __FILE__)

class VehicleTypesControllerTest < ActionController::TestCase
  context "with authorized user" do
    setup do
      @request = ActionController::TestRequest.new
      @project = Project.generate!
      @scenario = Scenario.generate!
      @project.scenarios << @scenario
      @request.session[:user_id] = 1
    end

    context "post create" do
      context "with valid params" do
        setup do
          @params = { :project_id => @project.id, 
                      :scenario_id => @scenario.id,
                      :vehicle_type => {:name => 'Heavy', 
                         :weight => 2.0} }
        end

        should "increase vehicle type count by 1" do
          assert_difference('VehicleType.count') do
            post :create, @params
          end
        end 

        context "as JSON" do
          setup do
            @params[:format] = 'json'
            post :create, @params
            @nice_response = JSON.parse(@response.body)
          end

          should "render as JSON" do
            assert @nice_response['success']
            assert_equal "#{@params[:vehicle_type][:name]}/#{@params[:vehicle_type][:weight]}", 
                         @nice_response['display']
          end
        end
      end
    end

    context "delete destroy" do
      context "with valid params" do
        setup do
          @vehicle_type = VehicleType.generate!
          @scenario.vehicle_types << @vehicle_type
          @params = { :project_id => @project.id, 
                      :scenario_id => @scenario.id,
                      :id => @vehicle_type.id }
        end
        
        should "reduce the vehicle type count by 1" do
          assert_difference('VehicleType.count', -1) do
            delete :destroy, @params
          end
        end
      end

      context "with only 1 vehicle type in scenario" do
        setup do
          @vehicle_type = VehicleType.generate!
          @scenario.vehicle_types = [@vehicle_type]
          @params = { :project_id => @project.id, 
                      :scenario_id => @scenario.id,
                      :id => @vehicle_type.id }
        end

        should "not change vehicle type count" do
          assert_no_difference('VehicleType.count') do
            delete :destroy, @params
          end
        end
      end
    end
  end
end
