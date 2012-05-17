class NotifyMailer < ActionMailer::Base
  default from: "feedbackloop@free.fr"

	def notify_feedback(this_survey_owner, this_survey_feedbacker, this_survey)
		@owner = this_survey_owner
		@feedbacker = this_survey_feedbacker
		@survey = this_survey

		mail(to: this_survey_owner.email, subject: "Your survey has feedback!")
	end
end
