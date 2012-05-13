class PasswordsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:password][:email]) 
		if user
			
			password = ('a'..'z').to_a.shuffle[0..9].join

    		user.password = user.password_confirmation = password
    		user.save

			ResetMailer.reset_password(user, password).deliver
		end
		flash[:success] = 'An email has been set with password reset instructions.'
		redirect_to signin_url
	end
end
