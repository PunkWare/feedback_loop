module QuestionsHelper
	def set_current_question_index(question)
		cookies.permanent[:current_question] = question.to_s
		@current_question = question
	end
	
	def current_question_index
		@current_question ||= cookies[:current_question].to_i
	end

	def set_questions_list(questions_list)
		cookies.permanent[:questions_list] = questions_list.join(',')
		@questions_list = questions_list.join(',')
	end
	
	def questions_list
		@questions_list ||= cookies[:questions_list]
	end

	def current_question
		question_id = questions_list_to_array[current_question_index]
		redirect_to(root_url, :alert => "Can't find question with id #{question_id}! Default to home page") if question_id.nil?
		Question.find(question_id)
	end

	def next_question?
		if (current_question_index + 1 ) >= questions_list_to_array.length
			return false
		else
			question_id = questions_list_to_array[ current_question_index + 1 ]
		end
	end

	def previous_question?
		if current_question_index.zero?
			return false
		else
			question_id = questions_list_to_array[ current_question_index - 1 ]
		end
	end

	def next_question
		question_id = next_question?

		if question_id
			set_current_question_index ( current_question_index + 1 )

			answer_exist = Answer.where(user_id: current_user.id, question_id: question_id)

			if answer_exist[0]
				edit_answer_path(answer_exist[0])
			else
				new_answer_path
			end
		end
	end

#	def previous_question
#		question_id = previous_question?
#
#		if question_id
#			set_current_question_index ( current_question_index - 1 )
#
#			answer_exist = Answer.where(user_id: current_user.id, question_id: question_id)
#
#			if answer_exist[0]
#				edit_answer_path(answer_exist[0])
#			else
#				nil
#			end
#		end
#	end

	private
		def questions_list_to_array
			current_list = questions_list.split(',')
			current_list.collect! {|x| x.to_i}
		end
end
