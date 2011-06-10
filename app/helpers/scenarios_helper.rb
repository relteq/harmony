module ScenariosHelper
  def redirect_to_dbweb_import_url(project_id)
    # Don't try to interpolate filename into string here, it's a JS
    # variable not known until upload is complete
    %Q{
        var redirect_url = '#{edit_project_configuration_scenario_path(@project, {:id => '**S_ID**'})}';
        $('ajax-indicator').show();
        $j.getJSON("#{ENV['DBWEB_URL_BASE']}/import/scenario/" + filename + "?jsoncallback=?",
          { 
              access_token: "#{@token}", 
              to_project:  "#{project_id}",
              bucket: "#{S3SwfUpload::S3Config.bucket}"
          }, 
          function(data) {
            if(data.success) {
              var edit_url = redirect_url.replace('**S_ID**',data.success);
              window.location = edit_url;
            }
            $('ajax-indicator').hide();
          }
        );
    }
  end
end
