module RelteqUserStamps
  def self.included(base)
    base.class_eval do
      belongs_to :creator, :class_name => 'User', :foreign_key => :user_id_creator
      belongs_to :modifier, :class_name => 'User', :foreign_key => :user_id_modifier
    end
  end
end
