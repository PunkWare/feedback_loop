module QuestionsHelper
	def current_question=(question)
		@current_question = question
	end
	
	def current_question
		@current_question
	end

	def current_question?(question)
		question == current_question
	end
end
