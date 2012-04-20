class Answer < ActiveRecord::Base
	attr_accessible :choice, :comment
	belongs_to :question
	belongs_to :user

	validates :question_id, presence: true
	validates :user_id, presence: true, uniqueness: { scope: :question_id}
	validates :choice, :numericality => {:greater_than => 0, :less_than => 11}

	#validate :choice_cannot_be_higher_than_number_of_choice_of_question

	#def choice_cannot_be_higher_than_number_of_choice_of_question
	#	if :choice > current_question.number_of_choices
	#		errors.add(:choice, "can't be in the past")
	#	end
	#end
end
