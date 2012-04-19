class AnswersController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_answer, only: [ :edit, :update]

	def create
		@answer = current_question.answers.build(params[:answer])

		if @answer.choice <= current_question.number_of_choices
			@answer.user = current_user
			if @answer.save
				flash[ :success ] = "Answer created."
					
				redirect_to root_url		
			else
				render 'new'
			end
		else
			#flash.now[ :error ] = "Choice must be betwwen 1 and "+current_question.number_of_choices.to_s
			@answer.errors.add(:choice, "must be betwwen 1 and "+current_question.number_of_choices.to_s)
			render 'new'
		end
	end
	
	def new
		@answer = current_question.answers.build
	end

	private
		def correct_user_of_answer
				answer = current_user.answers.find_by_id(params[:id])
				redirect_to(root_url, :alert => "Access prohibited! Default to home page") if answer.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_survey = Survey.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_survey
				#	@user = current_survey.user
				#end
				#redirect_to(root_url) unless current_user?(@user)
			end
end
