class SurveysController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user,    only: [:destroy, :edit, :update]

	def create
		@survey = current_user.surveys.build(params[:survey])
		if @survey.save
			flash[ :success ] = "Survey created."
				
			redirect_to user_surveys_path
				
		else
			render 'new'
		end
	end
	
	def new
		@survey = current_user.surveys.build
	end

	def edit
		@survey = Survey.find(params[:id]) 
	end

	def update
		@survey = Survey.find(params[:id])
		
		if @survey.update_attributes(params[:survey])
			
			flash[:success] = "Survey updated."
			
			redirect_to user_surveys_path
		else
			render 'edit'
		end
	end

	def destroy
		deleted_survey = Survey.find(params[:id]).destroy
		flash[:success] = "Survey deleted."
		redirect_to user_surveys_path
	end

	private

			def correct_user
				@survey = current_user.surveys.find_by_id(params[:id])
				redirect_to(root_path) if @survey.nil?

				# ANOTHER METHOD BELOW A LITTLE BIT 
				#current_survey = Survey.find_by_id(params[:id])
				##if a survey with this id exist
				#if current_survey
				#	@user = current_survey.user
				#end
				#redirect_to(root_path) unless current_user?(@user)
			end
end
