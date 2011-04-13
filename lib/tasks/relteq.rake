# Run specific tests or test files
# 
# rake reltest:blog
# => Runs the full BlogTest unit test
# 
# rake reltest:blog:create
# => Runs the tests matching /create/ in the BlogTest unit test
# 
# rake reltest:blog_controller
# => Runs all tests in the BlogControllerTest functional test
# 
# rake reltest:blog_controller
# => Runs the tests matching /create/ in the BlogControllerTest functional test	
namespace :reltest do
  rule /^reltest:/ do |t| _, file_name, test_name, * = t.name.split ":"
    # reltest:file:method
    
    if File.exist?("test/unit/#{file_name}_test.rb")
      run_file_name = "unit/#{file_name}_test.rb" 
    elsif File.exist?("test/functional/#{file_name}_controller_test.rb")
      run_file_name = "functional/#{file_name}_controller_test.rb" 
    elsif File.exist?("test/functional/#{file_name}_test.rb")
      run_file_name = "functional/#{file_name}_test.rb" 
    end
    
    sh "ruby -Ilib:test test/#{run_file_name} -n /#{test_name}/" 
  end
end