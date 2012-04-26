module AnswersHelper

	def list_of_choices(this_answer)
		list=[]
		for intermediate in (1..this_answer.question.number_of_choices) do
			pair = []
			pair.push intermediate.to_s
			pair.push intermediate
			list.push pair
		end

		return list
	end
end
