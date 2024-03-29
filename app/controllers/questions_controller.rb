class QuestionsController < ApplicationController
	before_filter :signed_in_user
	before_filter :survey_exists
	before_filter :correct_survey_of_question, only: [:destroy, :edit, :update, :show, :results]
	before_filter :not_anonymous_survey, only: :results

	def create
		@question = ApplicationController.current_survey.questions.build(params[:question])
		if @question.save
			flash[ :success ] = "Question created."
				
			redirect_to survey_url(ApplicationController.current_survey)
				
		else
			render 'new'
		end
	end
	
	def new
		@question = ApplicationController.current_survey.questions.build
	end

	def show
		@question = ApplicationController.current_survey.questions.find(params[:id])
		redirect_to(root_url, alert: "Can't find question with id #{params[:id]}! Default to home page") if @question.nil?

		#@answers = current_question.answers.paginate(page: params[:page])
	end

	def edit
		@question = ApplicationController.current_survey.questions.find(params[:id])
		redirect_to(root_url, alert: "Can't find question with id #{params[:id]}! Default to home page") if @question.nil?
	end

	def update
		@question = ApplicationController.current_survey.questions.find(params[:id])
		redirect_to(root_url, alert: "Can't find question with id #{params[:id]}! Default to home page") if @question.nil?
		
		if @question.update_attributes(params[:question])
			flash[:success] = "Question updated."
			
			redirect_to survey_url(ApplicationController.current_survey)
		else
			render 'edit'
		end
	end

	def destroy
		deleted_question = ApplicationController.current_survey.questions.find(params[:id])
		redirect_to(root_url, alert: "Can't find question with id #{params[:id]}! Default to home page") if deleted_question.nil?

		deleted_question.destroy
		flash[:success] = "Question deleted."

		if deleted_question.survey.questions.blank? && deleted_question.survey.available
			deleted_question.survey.available = false
			deleted_question.survey.save
			flash[:alert] = "This question was the last of the survey. As a result, the survey is not available for feedback anymore."
		end

		redirect_to survey_url(ApplicationController.current_survey)
	end

	def results
		@question = ApplicationController.current_survey.questions.find(params[:id])
		redirect_to(root_url, alert: "Can't find question with id #{params[:id]}! Default to home page") if @question.nil?
	end

	private

			def survey_exists
				redirect_to(root_url, alert: "No active survey! Default to home page") if ApplicationController.current_survey.nil?
			end

			def not_anonymous_survey
				survey = current_user.surveys.find_by_id(ApplicationController.current_survey)
				if survey.nil?
					redirect_to(root_url, alert: "Access prohibited! Default to home page") 
				else
					question = survey.questions.find_by_id(params[:id])
					redirect_to(root_url, alert: "Access prohibited! Default to home page") if question.survey.anonymous
				end
			end

			def correct_survey_of_question
				survey = current_user.surveys.find_by_id(ApplicationController.current_survey)
				if survey.nil?
					redirect_to(root_url, alert: "Access prohibited! Default to home page") 
				else
					question = survey.questions.find_by_id(params[:id])
					redirect_to(root_url, alert: "Access prohibited! Default to home page") if question.nil?
				end

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_question= Question.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_question
				#	survey = current_queston.survey
				#end
				#redirect_to(root_url) unless current_survey?(@user)
			end
end
