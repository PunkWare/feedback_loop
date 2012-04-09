class Question < ActiveRecord::Base
	attr_accessible :title, :low_choice, :high_choice, :number_of_choices
	belongs_to :survey

	validates :survey_id,	presence: true
	validates :title,			presence: true
	validates :low_choice,	presence: true
	validates :high_choice,	presence: true
	validates_numericality_of :number_of_choices, :only_integer => true


	default_scope order: 'questions.created_at'
end
