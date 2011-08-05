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
  
  def get_url_for_file(mdat)
    link = mdat.s3_url #s3_url will also set valid url to make sure you were able to locate file in s3
    if(mdat.valid_url)
       return link_to(l(:relteq_s3_link_to_file), link, :target => :blank)
    end
    return link
  end
end
