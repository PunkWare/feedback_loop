class PasswordsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:password][:email]) 
		if user
			
			password = SecureRandom.urlsafe_base64[0..9]

			user.password = user.password_confirmation = password
			user.save

			ResetMailer.reset_password(user, password).deliver
		end
		flash[:success] = 'An email has been set with password reset instructions.'
		redirect_to signin_url
	end
end
