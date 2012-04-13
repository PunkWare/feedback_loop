module SurveysHelper
	def set_current_survey(survey)
		cookies.permanent[:survey_token] = survey.key
		@current_survey = survey
	end

	def current_survey=(survey)
		cookies.permanent[:survey_token] = survey.key
		@current_survey = survey
	end
	
	def current_survey
		@current_survey ||= survey_from_cookie
	end

	def current_survey?(survey)
		survey == current_survey
	end

	private

		def survey_from_cookie
			survey_token = cookies[:survey_token]
			Survey.find_by_key(survey_token) unless survey_token.nil?
		end
end