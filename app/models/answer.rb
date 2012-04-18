class Answer < ActiveRecord::Base
	attr_accessible :choice, :comment
	belongs_to :question
	belongs_to :user

	validates :question_id, presence: true
	validates :user_id, presence: true, :uniqueness => { :scope => :question_id}
	validates :choice, :numericality => {:greater_than => 0, :less_than => 11}
end
