module SurveysHelper
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
end