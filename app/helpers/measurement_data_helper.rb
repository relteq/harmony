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
end
