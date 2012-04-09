module SurveysHelper
	def current_survey=(survey)
		@current_survey = survey
	end
	
	def current_survey
		@current_survey
	end

	def current_survey?(survey)
		survey == current_survey
	end
end
