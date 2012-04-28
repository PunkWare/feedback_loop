class AnswersController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_of_answer, only: [ :edit, :update]
	before_filter :ready_to_feedback

	def create
		@answer = ApplicationController.current_question.answers.build(params[:answer])

		if @answer.choice && @answer.choice <= @answer.question.number_of_choices
			@answer.user = current_user
			if @answer.save
				flash[ :success ] = "Answer created."
					
				if question_after?(@answer.question)
					redirect_to answer_path_for_question_after(@answer.question)
				else
					redirect_to end_path
				end
			else
				render 'new'
			end
		else
			@answer.errors.add(:choice, "must be between 1 and " + @answer.question.number_of_choices.to_s)
			render 'new'
		end
	end
	
	def new
		@answer = ApplicationController.current_question.answers.build
	end

	def edit
		if params[:backward] == "true"
			ApplicationController.set_current_question(question_before?(ApplicationController.current_question))
		end

		@answer = ApplicationController.current_question.answers.find(params[:id])
		redirect_to(root_url, :alert => "Can't find answer with id #{params[:id]}! Default to home page.") if ! ApplicationController.current_survey.questions.index(@answer.question)
	end

	
	def update
		@answer = ApplicationController.current_question.answers.find(params[:id])
		redirect_to(root_url, :alert => "Can't find answer with id #{params[:id]}! Default to home page.") if ! ApplicationController.current_survey.questions.index(@answer.question)

		if params[:answer][:choice] && (params[:answer][:choice].to_i <= @answer.question.number_of_choices)
			if @answer.update_attributes(params[:answer])
				flash[ :success ] = "Answer saved."
					
				if question_after?(@answer.question)
					redirect_to answer_path_for_question_after(@answer.question)
				else
					redirect_to end_path
				end
			else
				render 'edit'
			end
		else
			@answer.errors.add(:choice, "must be between 1 and " + @answer.question.number_of_choices.to_s)
			render 'edit'
		end
	end

	private
		def correct_user_of_answer
			answer = current_user.answers.find_by_id(params[:id])
			redirect_to(root_url, :alert => "Access prohibited! Default to home page.") if answer.nil?
		end

		def ready_to_feedback
			answer = current_user.answers.find_by_id(params[:id])
			redirect_to(begin_survey_path(answer.question.survey), :alert => "Access to this answer is allowed only by giving feedback to this survey.") if ApplicationController.current_survey.nil? || ApplicationController.current_survey.questions.blank?
		end
end
