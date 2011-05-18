namespace :import do
  task :tests do
    import_file = "lib/import/import-test/test3.xml"
    sh "lib/import/bin/import-tests " + import_file 
  end

  task :live do
    import_file = ENV['import_file']
    sh "lib/import/bin/import-tests " + import_file 
  end 
end