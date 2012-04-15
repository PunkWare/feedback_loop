class Answer < ActiveRecord::Base
	attr_accessible :choice, :comment
	belongs_to :question
	belongs_to :user

	validates :question_id, presence: true
	validates :user_id, presence: true
	validates :choice, presence: true
end
