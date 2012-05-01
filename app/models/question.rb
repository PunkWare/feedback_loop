class Question < ActiveRecord::Base
	attr_accessible :title, :first_choice, :last_choice, :number_of_choices, :link
	belongs_to :survey
	has_many :answers, dependent: :destroy
	#has_many :users, :through => :answers
	before_save :well_formed_uri

	validates :survey_id, presence: true
	validates :title, presence: true
	validates :first_choice, presence: true
	validates :last_choice,	presence: true
	validates :number_of_choices, numericality: {greater_than: 1, less_than_or_equal_to: MAX_CHOICES}


	default_scope order: 'questions.created_at'

	private
		def well_formed_uri
			self.link = ("http://" << self.link) if ! self.link.nil? and self.link.start_with?('www') 
		end
end
