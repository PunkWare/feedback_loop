module QuestionsHelper

	def question_index(this_question)
		position = current_survey.questions.index(this_question)

		if ! position
			redirect_to(root_url, :alert => "Can't find position for question! Default to home page")
		else
			position
		end
	end


	def question_after?(this_question)
		position = current_survey.questions.index(this_question)

		if ! position
			redirect_to(root_url, :alert => "Can't find position for question! Default to home page")
		else
			if ( position + 1 ) >= current_survey.questions.length
				false
			else
				current_survey.questions[ position + 1]
			end
		end
	end

	def question_before?(this_question)
		position = current_survey.questions.index(this_question)

		if ! position
			redirect_to(root_url, :alert => "Can't find position for question! Default to home page")
		else
			if position.zero?
				false
			else
				current_survey.questions[ position - 1]
			end
		end
	end

	def answer_path_for_question(this_question)
		if this_question
			answer_exist = Answer.where(user_id: current_user.id, question_id: this_question.id)

			ApplicationController.set_current_question(this_question)

			if answer_exist.first
				edit_answer_path(answer_exist.first, backward: false)
			else
				new_answer_path
			end
		else
			redirect_to(root_url, :alert => "Can't find question! Default to home page")
		end
	end

	def answer_path_for_question_after(this_question)
		question = question_after?(this_question)

		if question
			answer_exist = Answer.where(user_id: current_user.id, question_id: question.id)

			ApplicationController.set_current_question(question)

			if answer_exist.first
				edit_answer_path(answer_exist.first, backward: false)
			else
				new_answer_path
			end
		else
			redirect_to(root_url, :alert => "Can't find question! Default to home page")
		end
	end

	def answer_path_for_question_before(this_question)
		question = question_before?(this_question)

		if question
			answer_exist = Answer.where(user_id: current_user.id, question_id: question.id)

			if answer_exist.first
				edit_answer_path(answer_exist.first, backward: true)
			else
				redirect_to(root_url, :alert => "Can't find answer with question id #{question_id}! Default to home page")
			end
		else
			redirect_to(root_url, :alert => "Can't find question! Default to home page")
		end
	end

	def list_of_choices_for_question(this_question)
		list=[]
		for choice in (2..MAX_CHOICES) do
			pair = []
			pair.push choice.to_s
			pair.push choice
			list.push pair
		end

		return list
	end
end
