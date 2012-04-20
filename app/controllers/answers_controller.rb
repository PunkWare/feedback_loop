class AnswersController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_of_answer, only: [ :edit, :update]
	before_filter :ready_to_feedback

	def create
		@answer = current_question.answers.build(params[:answer])

		if @answer.choice && @answer.choice <= current_question.number_of_choices
			@answer.user = current_user
			if @answer.save
				flash[ :success ] = "Answer created."
					
				redirect_to root_url		
			else
				render 'new'
			end
		else
			@answer.errors.add(:choice, "must be between 1 and "+current_question.number_of_choices.to_s)
			render 'new'
		end
	end
	
	def new
		@answer = current_question.answers.build
	end

	def edit
		@answer = current_question.answers.find(params[:id])

		redirect_to(root_url, :alert => "Can't find answer with id #{params[:id]}! Default to home page.") if @answer.nil?
	end

	
	def update
		@answer = current_question.answers.find(params[:id])
		redirect_to(root_url, :alert => "Can't find answer with id #{params[:id]}! Default to home page.") if @answer.nil?

		if params[:answer][:choice] && (params[:answer][:choice].to_i <= current_question.number_of_choices)
			if @answer.update_attributes(params[:answer])
				flash[ :success ] = "Answer saved."
					
				redirect_to root_url		
			else
				render 'edit'
			end
		else
			@answer.errors.add(:choice, "must be between 1 and "+current_question.number_of_choices.to_s)
			render 'edit'
		end
	end

	private
		def correct_user_of_answer
			answer = current_user.answers.find_by_id(params[:id])
			redirect_to(root_url, :alert => "Access prohibited! Default to home page.") if answer.nil?

			# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
			#current_survey = Survey.find_by_id(params[:id])
			##if a survey with this id exist
			#if current_survey
			#	@user = current_survey.user
			#end
			#redirect_to(root_url) unless current_user?(@user)
		end

		def ready_to_feedback
			answer = current_user.answers.find_by_id(params[:id])
			redirect_to(begin_survey_path(answer.question.survey), :alert => "Access to this answer is allowed only by giving feedback to this survey.") if current_survey.nil? || questions_list.nil? || questions_list.blank?		
		end
end
