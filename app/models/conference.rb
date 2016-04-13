class Conference < ActiveRecord::Base
	has_many :divisions, :foreign_key => 'conf_id'
	has_many :teams, :through => :divisions
end
