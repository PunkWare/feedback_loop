class ResetMailer < ActionMailer::Base
	default from: "feedbackloop@free.fr"

	def reset_password(this_user, this_password)
		@user = this_user
		@password = this_password

		mail(:to => this_user.email, :subject => "Reset your Feedback Loop password")
	end
end
