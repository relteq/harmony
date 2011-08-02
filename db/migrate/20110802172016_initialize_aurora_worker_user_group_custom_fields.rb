class InitializeAuroraWorkerUserGroupCustomFields < ActiveRecord::Migration
  def self.up
    UserCustomField.create!(
      :name => 'aurora_worker_user', 
      :field_format => 'string',
      :default_value => ENV['AURORA_WORKER_USER'],
      :editable => false
    )
    UserCustomField.create!(
      :name => 'aurora_worker_group', 
      :field_format => 'string',
      :default_value => ENV['AURORA_WORKER_GROUP'],
      :editable => false
    )
  end

  def self.down
    UserCustomField.find_by_name('aurora_worker_user').destroy
    UserCustomField.find_by_name('aurora_worker_group').destroy
  end
end
