class SurveysController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_of_survey,    only: [ :destroy, :edit, :update, :show ]
	before_filter :feedbackable, only: [ :begin ]

	def create
		@survey = current_user.surveys.build(params[:survey])
		if @survey.save
			set_current_survey(@survey)
			flash[ :success ] = "Survey created."
				
			redirect_to survey_path(current_survey)
				
		else
			render 'new'
		end
	end
	
	def new
		@survey = current_user.surveys.build
		set_current_survey(@survey)
	end

	def show
		@survey = current_user.surveys.find(params[:id])
		set_current_survey(@survey)
		@questions = @survey.questions.paginate(page: params[:page])
	end

	def edit
		@survey = current_user.surveys.find(params[:id])
		set_current_survey(@survey)
	end

	def update
		@survey = current_user.surveys.find(params[:id])

		#flash[:notice] = params[:survey].to_s

		# cannot make a survey available if it has no question
		if params[:survey][:available] == "1" and !has_question?(@survey)
			flash[:error] = "Survey has been set back to unavailable because the survey has currently no associated question."
			params[:survey][:available] = "0"
		end

		# cannot make a survey not anonymous if it has answer
		if params[:survey][:anonymous] == "0" and has_answer?(@survey)
			flash[:error] = "Survey has been set back to anonymous because the survey has some answers. It cannot be changed anymore."
			params[:survey][:anonymous] = "1"
		end
		
		if @survey.update_attributes(params[:survey])
			set_current_survey(@survey)
			flash[:success] = "Survey updated."
			
			redirect_to user_surveys_path
		else
			render 'edit'
		end
	end

	def begin
		#if ! (Survey.find_by_id(params[:id]) == nil)
			@survey = Survey.find(params[:id])
			set_current_survey(@survey)
			@questions = @survey.questions
		#else
		#	redirect_to root_path
		#end
	end

	def destroy
		deleted_survey = current_user.surveys.find(params[:id]).destroy
		current_survey = nil if current_survey?(deleted_survey)
		flash[:success] = "Survey deleted."
		redirect_to user_surveys_path
	end

	private

			def correct_user_of_survey
				survey = current_user.surveys.find_by_id(params[:id])
				redirect_to(root_path) if survey.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_survey = Survey.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_survey
				#	@user = current_survey.user
				#end
				#redirect_to(root_path) unless current_user?(@user)
			end

			def feedbackable
				found = false

				feedback_survey = Survey.find_by_id(params[:id])

				if !feedback_survey.nil?
					if has_question?(feedback_survey)
						surveys = Survey.where(:available => true, :private => false)
						
						surveys.each do |survey|
							if survey.id == feedback_survey.id
								found = true
							end
						end
					end
				end

				redirect_to(root_path) if !found
			end

end
