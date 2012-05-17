require 'spec_helper'

describe "Password pages" do
	subject { page }

	shared_examples_for "all password pages" do
		it { should have_title(full_title(page_title)) }
		it { should have_heading(heading) }
	end

	describe "When testing reset password page, " do
		before { visit reset_path }
		let(:heading) {'Reset password'}
		let(:page_title) {heading}
		let(:reset_password_button) {'Send'}

		it_should_behave_like "all password pages"
		it { should have_button(reset_password_button) }

		describe "when filling fields on new page" do
			let(:email) { "fake@fake.fake" }
			let(:password) { "fakefake" }
			let!(:user) { FactoryGirl.create(:user, email: email, password: password, password_confirmation: password ) }

			describe " with valid information, " do
				before do
					fill_in "Email", with: email
				end

				describe "it should create an email" do
					before do
						ActionMailer::Base.deliveries.clear
						click_button reset_password_button
					end

					it "and sends the email" do
						assert !ActionMailer::Base.deliveries.empty?, "Queue is empty"
						ActionMailer::Base.deliveries.last.to.should == [user.email]
						ActionMailer::Base.deliveries.last.subject.should == "Reset your Feedback Loop password"
					end
				end

				describe "after the email is sent, " do
					before { click_button reset_password_button }
					
					it { should have_title(full_title('Sign in')) }

					it { should have_flash_message('An email has been set with password reset instructions.','success') }

					describe "When trying to sign in with the old password, " do
						let(:sign_in_button) {'Sign in'}

						before do
							visit signin_path
							fill_in "Email", 		with: user.email
							fill_in "Password", 	with: password
						end

						describe "and when clicking the sign in button" do
							before { click_button sign_in_button }

							it { should have_flash_message('Invalid email/password combination','error') }
						end
					end

					describe "When trying to sign in with the new password, " do
						let(:sign_in_button) {'Sign in'}

						before do
							visit signin_path
							fill_in "Email", 		with: user.email
							fill_in "Password", 	with: new_password(ActionMailer::Base.deliveries.last.body.encoded)
						end

						describe "and when clicking the sign in button, " do
							before { click_button sign_in_button }

							it { should have_title('All surveys') }
						end
					end
				end
			end
		end
	end
end