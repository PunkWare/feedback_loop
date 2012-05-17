require "spec_helper"

describe NotifyMailer do
  describe 'notify_feedback' do
		let(:owner_email_address) { "fake@fake.fake" }
		let(:feedbacker_email_address) { "another_fake@fake.fake" }
		let!(:owner) { FactoryGirl.create(:user, email: owner_email_address ) }
		let!(:feedbacker) { FactoryGirl.create(:user, email: feedbacker_email_address ) }
		let!(:survey) { FactoryGirl.create(:survey, user: owner, title: "Survey 1") }

		let(:email) { NotifyMailer.notify_feedback(owner, feedbacker, survey) }

		#ensure that the subject is correct
		it 'has the correct subject' do
			email.subject.should == 'Your survey has feedback!'
		end

		#ensure that the receiver is correct
		it 'has the correct email address' do
			email.to.should == [owner.email]
		end

		#ensure that the sender is correct
		it 'has the correct sender email' do
			email.from.should == ['feedbackloop@free.fr']
		end

		it 'includes the survey title' do
			email.body.encoded.should match(survey.title)
		end

		it 'includes the feedbacker name' do
			email.body.encoded.should match(feedbacker.name)
		end
	end
end
