module MeasurementDataHelper
  def measurement_data_select_options()
    return [
      ['Select Action ...' , ''],
      ['Import Data File' , 'import']
    ]
  end
  
  def measurement_data_file_type_of_select_options
    return  [
     ['Measurement Data' ],
     ['Meta Data' ],
     ['Health Data' ]
    ]
  end
  
  def redirect_to_dbweb_import_url(project_id, user_id)
    # Don't try to interpolate filename into string here, it's a JS
    # variable not known until upload is complete
    %Q{
        upload_success = true;
        $('ajax-indicator').show();
        $j.getJSON("#{ENV['DBWEB_URL_BASE']}/import/measurement_data/" + filename + "?jsoncallback=?",
          { 
              access_token: "#{@token}", 
              to_project:  "#{project_id}",
              from_user: "#{user_id}",
              bucket: "#{S3SwfUpload::S3Config.bucket}"
          }, 
          function(data) {
            $('ajax-indicator').hide();
          }
        );
    }
  end
  
  def link_name_to_file_url_or_not(mdat)
    if (mdat.get_appropriate_url.blank?)
      return mdat.name
    else
      return link_to_function(mdat.name,"show_box('#{mdat.id}-url-copy');")
    end
  end

end
