class ControllerSet < ActiveRecord::Base
  generator_for :network, :method => :new_network
  generator_for :name, :method => :next_name

  def self.new_network
    Network.generate!
  end

  def self.next_name
    @last_name ||= 'Controller Set 0'
    @last_name.succ!
    @last_name
  end
end
