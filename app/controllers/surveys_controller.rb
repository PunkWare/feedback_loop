class SurveysController < ApplicationController
	before_filter :signed_in_user

	def destroy
    deleted_survey = Survey.find(params[:id]).destroy
    flash[:success] = "Survey deleted."
    redirect_to user_surveys_path
  end
end
