class AnswersController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_answer, only: [ :edit, :update]

	def create
		@answer = current_question.answers.build(params[:answer])
		@answer.user = current_user
		if @answer.save
			flash[ :success ] = "Answer created."
				
			redirect_to root_path		
		else
			render 'new'
		end
	end
	
	def new
		@answer = current_question.answers.build
	end

	private
		def correct_user_of_answer
				answer = current_user.answers.find_by_id(params[:id])
				redirect_to(root_path) if answer.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_survey = Survey.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_survey
				#	@user = current_survey.user
				#end
				#redirect_to(root_path) unless current_user?(@user)
			end
end
