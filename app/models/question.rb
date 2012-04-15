class Question < ActiveRecord::Base
	attr_accessible :title, :first_choice, :last_choice, :number_of_choices
	belongs_to :survey
	has_many :answers, dependent: :destroy
	#has_many :users, :through => :answers

	validates :survey_id, presence: true
	validates :title, presence: true
	validates :first_choice, presence: true
	validates :last_choice,	presence: true
	validates :number_of_choices, :numericality => {:greater_than => 1, :less_than => 11}


	default_scope order: 'questions.created_at'
end
