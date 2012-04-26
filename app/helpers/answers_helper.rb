module AnswersHelper

	def list_of_choices_for_answer(this_answer)
		list=[]
		for choice in (1..this_answer.question.number_of_choices) do
			pair = []
			pair.push choice.to_s
			pair.push choice
			list.push pair
		end

		return list
	end
end
