class QuestionsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_survey_of_question, only: [:destroy, :edit, :update, :show]

	def create
		@question = current_survey.question.build(params[:question])
		if @question.save
			current_question = @question
			flash[ :success ] = "Question created."
				
			redirect_to survey_path(current_survey)
				
		else
			render 'new'
		end
	end
	
	def new
		@question = current_survey.questions.build
		current_question = @question
	end

	def show
		@question = current_survey.questions.find(params[:id])
		current_question = @question
		#@answers = current_question.answers.paginate(page: params[:page])
	end

	def edit
		@question = current_survey.questions.find(params[:id])
		current_question = @question
	end

	def update
		@question = current_survey.questions.find(params[:id])
		
		if @question.update_attributes(params[:question])
			current_question = @question
			flash[:success] = "Question updated."
			
			redirect_to survey_path(current_survey)
		else
			render 'edit'
		end
	end

	def destroy
		deleted_question = current_survey.questions.find(params[:id]).destroy
		current_question = nil
		flash[:success] = "Question deleted."
		redirect_to survey_path(current_survey)
	end

	private

			def correct_survey_of_question
				if current_survey.nil?
					redirect_to(root_path) 
					return
				end
				question = current_survey.questions.find_by_id(params[:id])
				redirect_to(root_path) if question.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_question= Question.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_question
				#	survey = current_queston.survey
				#end
				#redirect_to(root_path) unless current_survey?(@user)
			end
end
