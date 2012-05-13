require "spec_helper"

describe ResetMailer do
	describe 'reset_mailer' do
		let(:email_address) { "fake@fake.fake" }
		let(:password) { "fakefake" }
		let!(:user) { FactoryGirl.create(:user, name: "imfake", email: email_address, password: password, password_confirmation: password ) }

		let(:email) { ResetMailer.reset_password(user, password) }

		#ensure that the subject is correct
		it 'has the correct subject' do
			email.subject.should == 'Reset your Feedback Loop password'
		end

		#ensure that the receiver is correct
		it 'has the correct email address' do
			email.to.should == [user.email]
		end

		#ensure that the sender is correct
		it 'has the correct sender email' do
			email.from.should == ['feedbackloop@free.fr']
		end

		#ensure that the password variable appears in the email body
		it 'includes the password' do
			email.body.encoded.should match(password)
		end
	end
end
