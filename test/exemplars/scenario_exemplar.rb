class Scenario < ActiveRecord::Base
  generator_for :name, :method => :next_name
  generator_for :network, :method => :new_network

  def self.next_name
    @last_name ||= 'Scenario 0'
    @last_name.succ!
    @last_name
  end

  def self.new_network
    Network.generate! 
  end
end
