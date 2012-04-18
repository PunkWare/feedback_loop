module QuestionsHelper
	def set_current_question_index(question)
		cookies[:current_question] = { :value => question.to_s, :expires => 1.day.from_now }
		@current_question = question
	end
	
	def current_question_index
		@current_question ||= cookies[:current_question].to_i
	end

	def set_questions_list(questions_list)
		cookies[:questions_list] = { :value => questions_list.join(','), :expires => 1.day.from_now }
		@questions_list = questions_list
	end
	
	def questions_list
		@questions_list ||= cookies[:questions_list]
	end

	def current_question
		question_id = questions_list_to_array[current_question_index]
		redirect_to(root_url, :alert => "Can't find question with id #{question_id}! Default to home page") if question_id.nil?
		Question.find(question_id)
	end

	def next_question
		if (current_question_index + 1 ) == questions_list_to_array.length
			return nil
		else
			question_id = questions_list_to_array[ current_question_index + 1 ]
			redirect_to(root_url, :alert => "Can't find question with id #{question_id}! Default to home page") if question_id.nil?
			Question.find(question_id)
		end
	end

	def previous_question
		if current_question_index.zero?
			return nil
		else
			question_id = questions_list_to_array[ current_question_index - 1 ]
			redirect_to(root_url, :alert => "Can't find question with id #{question_id}! Default to home page") if question_id.nil?
			Question.find(question_id)
		end
	end

	private
		def questions_list_to_array
			current_list = questions_list.split(',')
			current_list.collect! {|x| x.to_i}
		end
end
