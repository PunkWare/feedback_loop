class SurveysController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_of_survey,    only: [ :destroy, :edit, :update, :show, :results ]
	before_filter :feedbackable, only: [ :begin ]

	def create
		@survey = current_user.surveys.build(params[:survey])
		if @survey.save
			ApplicationController.set_current_survey(@survey)
			flash[ :success ] = "Survey created."
				
			redirect_to survey_url(ApplicationController.current_survey)
				
		else
			render 'new'
		end
	end
	
	def new
		@survey = current_user.surveys.build
		ApplicationController.set_current_survey(@survey)
	end

	def show
		@survey = current_user.surveys.find(params[:id])		
		ApplicationController.set_current_survey(@survey)

		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if @survey.nil?

		@questions = @survey.questions.paginate(page: params[:page])
	end

	def edit
		@survey = current_user.surveys.find(params[:id])
		ApplicationController.set_current_survey(@survey)

		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if @survey.nil?
	end

	def update
		@survey = current_user.surveys.find(params[:id])
		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if @survey.nil?

		# cannot make a survey available if it has no question
		if params[:survey][:available] == "1" and ! has_question?(@survey)
			flash[:error] = "Survey has been set back to unavailable because the survey has currently no associated question."
			params[:survey][:available] = "0"
		end

		# cannot make a survey not anonymous if it has answer
		if params[:survey][:anonymous] == "0" and has_answer?(@survey) and @survey.anonymous
			flash[:error] = "Survey has been set back to anonymous because the survey has some answers. It cannot be changed anymore."
			params[:survey][:anonymous] = "1"
		end
		
		if @survey.update_attributes(params[:survey])
			ApplicationController.set_current_survey(@survey)
			flash[:success] = "Survey updated."
			
			redirect_to user_surveys_url
		else
			render 'edit'
		end
	end

	def begin
		@survey = Survey.find(params[:id])
		ApplicationController.set_current_survey(@survey)
		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if @survey.nil?

		@questions = @survey.questions
		redirect_to(root_url, alert: "Can't find questions for survey with id #{params[:id]}! Default to home page") if @questions.nil?

	end

	def results
		@survey = current_user.surveys.find(params[:id])
		ApplicationController.set_current_survey(@survey)

		flash.now[:alert] = "The survey is still available to surveyed. The results may change at anytime." if @survey.available

		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if @survey.nil?
	end

	def destroy
		deleted_survey = current_user.surveys.find(params[:id])
		redirect_to(root_url, alert: "Can't find survey with id #{params[:id]}! Default to home page") if deleted_survey.nil?


		deleted_survey.destroy
		ApplicationController.set_current_survey(nil) if ApplicationController.current_survey?(deleted_survey)
		flash[:success] = "Survey deleted."
		redirect_to user_surveys_url
	end

	private

			def correct_user_of_survey
				survey = current_user.surveys.find_by_id(params[:id])
				redirect_to(root_url, alert: "Access prohibited! Default to home page") if survey.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT LESS SECURE
				#current_survey = Survey.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_survey
				#	@user = current_survey.user
				#end
				#redirect_to(root_url) unless current_user?(@user)
			end

			def feedbackable
				found = false

				feedback_survey = Survey.find_by_id(params[:id])

				if ! feedback_survey.nil?
					if has_question?(feedback_survey)
						non_private_surveys	= Survey.where(available: true, private: false)
						private_surveys 		= Survey.joins(:accesses).where(available: true, accesses: { user_id: current_user.id })

						merged_surveys = non_private_surveys.concat(private_surveys)
						if merged_surveys.find {|x| x.id == feedback_survey.id }
							found = true
						end
					end
				end
				redirect_to(root_url, alert: "Survey with id #{params[:id]} is not ready for feedback! Default to home page") if ! found
			end

end
