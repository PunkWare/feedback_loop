class ApplicationController < ActionController::Base
	protect_from_forgery
	include SurveysHelper
	include SessionsHelper
	include QuestionsHelper

	@current_question = nil

	def self.set_current_question(this_question)
		@current_question = this_question
	end

	def self.current_question
		@current_question
	end
	
end
