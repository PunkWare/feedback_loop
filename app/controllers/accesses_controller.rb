class AccessesController < ApplicationController
	before_filter :signed_in_user

	def new
		@access = Access.new
	end

	def create
		@access = Access.new
		access_key = params[:key]

		accessed_survey = Survey.find_by_key(access_key)

		if accessed_survey
			if accessed_survey.accesses.find_by_user_id(current_user)
				flash.now[ :alert ] = 'You have joined this survey already.'
				render 'new'
			else
				@access = accessed_survey.accesses.build()
				@access.user = current_user

				if @access.save
					flash[ :success ] = 'You have joined the private survey "' << accessed_survey.title << '".'
					
					redirect_to root_url
				else
					render 'new'
				end
			end
		else
			flash.now[ :error ] = 'The key you entered is not valid.'
			render 'new'
		end
	end
end
