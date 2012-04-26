module SurveysHelper
	def set_current_survey(survey)
		cookies.permanent[:survey_token] = survey.key
		@current_survey = survey
	end
	
	def current_survey
		@current_survey ||= survey_from_cookie
	end

	def current_survey?(survey)
		survey == current_survey
	end

	def has_answer?(survey)
		questions=survey.questions
		if questions.blank?
			return false
		end

		questions.each do |question|
   		answers=question.answers
   		if answers.any?
   			return true
   		end
		end
		return false
	end

	def has_question?(survey)
		questions=survey.questions
		if questions.blank?
			return false
		else
			return true
		end
	end

	private

		def survey_from_cookie
			survey_token = cookies[:survey_token]
			Survey.find_by_key(survey_token) unless survey_token.nil?
		end
end