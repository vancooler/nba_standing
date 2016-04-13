class Team < ActiveRecord::Base
	belongs_to :division, :foreign_key => 'div_id'
	has_one :conference, :through => :division
	has_many :standings 
end
