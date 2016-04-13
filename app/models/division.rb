class Division < ActiveRecord::Base
	belongs_to :conference, :foreign_key => 'conf_id'
	has_many :teams, :foreign_key => 'div_id'
end
