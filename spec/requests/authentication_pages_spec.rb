require 'spec_helper'

describe "Signin, and signout pages" do
	subject { page }

	shared_examples_for "all authentication pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end

	describe "When testing title and h1 on sign in page, " do
		before { visit signin_path }
		let(:heading) {'Sign in'}
		let(:page_title) {heading}

		it_should_behave_like "all authentication pages"
	end

	describe "When providing sign in fields" do
		let(:sign_in_button) {'Sign in'}

		before { visit signin_path }

		describe "with invalid information" do
			before { click_button sign_in_button }

			it { should have_flash_message('Invalid email/password combination','error') }

			# making sure that the flash message doesn't stay when going to another page
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
		
			before { sign_in user }

			it { should have_title('All surveys') }
		
			it { should have_link('Update Profile', href: edit_user_path(user)) }
			it { should have_link('Sign out',     href: signout_path) }
			it { should_not have_link('Sign in',  href: signin_path) }
			it { should_not have_link('Users',    href: users_path) }
		
			describe "When clicking signout linking" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end
end

describe "Authenticated pages" do
	subject { page }

	describe "for non-signed-in users" do
		let(:user) { FactoryGirl.create(:user) }

		describe "when viewing home page" do
			before { visit root_path }

			it { should_not have_link('View Profile', href: user_path(user)) }
			it { should_not have_link('Update Profile', href: edit_user_path(user)) }
			it { should_not have_link('Sign out',     href: signout_path) }
			it { should have_link('Sign in',          href: signin_path) }
			it { should_not have_link('Users',        href: users_path) }

		end

		describe "when trying to view a profile page" do
			before { visit user_path(user) }

			# it shouldn't allow to go to view profile page, and forward to sign in page instead
			it { should have_title('Sign in') }
		end

		describe "when trying a show action" do
			before { get user_path(user) }

			# it shouldn't allow to go to view profile page, and forward to sign in page instead
			specify { response.should redirect_to(signin_url) }
		end

		describe "when trying to edit a profile page" do
			before { visit edit_user_path(user) }

			# it shouldn't allow to go to edit profile page, and forward to sign in page instead
			it { should have_title('Sign in') }
		end

		describe "when trying an update action" do
			before { put user_path(user) }

			# it shouldn't allow to go to edit profile page, and forward to sign in page instead
			specify { response.should redirect_to(signin_url) }
		end
		
		describe "when trying to view the users page" do
			before { visit users_path }

			# it shouldn't allow to go to users index page, and forward to root page instead
			it { should have_title('Home') }
		end
		
		describe "when trying a get index action" do
			before { get users_path }

			# it shouldn't allow to go to view profile page, and forward to sign in page instead
			specify { response.should redirect_to(root_url) }
		end

		describe "in the Surveys controller" do

			describe "submitting to the create action" do
				before { post surveys_path }
				specify { response.should redirect_to(signin_url) }
			end

			describe "when trying to show a survey" do
				let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }

				describe "visiting the show survey page" do
					before { visit survey_path(survey) }

					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { get survey_path(survey)  }

					specify { response.should redirect_to(signin_url) }
				end
			end

			describe "when trying to edit a survey" do
				let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }

				describe "visiting the edit survey page" do
					before { visit edit_survey_path(survey) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { put survey_path(survey) }
					specify { response.should redirect_to(signin_url) }
				end
			end

			describe "submitting to the destroy action" do
				before do
					survey = FactoryGirl.create(:survey)
					delete survey_path(survey)
				end
				specify { response.should redirect_to(signin_url) }
			end
		end

		describe "in the Questions controller" do

			describe "submitting to the create action" do
				before { post questions_path }
				specify { response.should redirect_to(signin_url) }
			end

			describe "when trying to show a question" do
				let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
				let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }

				describe "visiting the show question page" do
					before { visit question_path(question) }

					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { get question_path(question)  }

					specify { response.should redirect_to(signin_url) }
				end
			end

			describe "when trying to edit a question" do
				let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
				let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }

				describe "visiting the edit question page" do
					before { visit edit_question_path(question) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { put question_path(question) }
					specify { response.should redirect_to(signin_url) }
				end
			end

			describe "submitting to the destroy action" do
				before do
					question = FactoryGirl.create(:question)
					delete question_path(question)
				end
				specify { response.should redirect_to(signin_url) }
			end
		end

		describe "in the Answers controller" do

			describe "submitting to the create action" do
				before { post answers_path }
				specify { response.should redirect_to(signin_url) }
			end

			describe "when trying to edit an answer" do
				let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
				let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
				let(:answer) { FactoryGirl.create(:answer, question: question, user: user, choice: 3) }

				describe "visiting the edit answer page" do
					before { visit edit_answer_path(answer) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { put answer_path(answer) }
					specify { response.should redirect_to(signin_url) }
				end
			end
		end

		describe "when trying to join a private survey" do
			before { visit new_access_path }

			it { should have_title('Sign in') }
		end
	end

	describe "for signed-in users" do
		let(:user) { FactoryGirl.create(:user) }
		let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
		before { sign_in user }

		describe "when trying to edit the profile of another user" do
			before { visit edit_user_path(wrong_user) }
			it { should have_title('') }
		end

		describe "when trying to view the profile of another user" do
			before { visit user_path(wrong_user) }
			it { should have_title('') }
		end

		describe "when submitting a PUT request to the Users#update action" do
			before { put user_path(wrong_user) }
			specify { response.should redirect_to(root_url) }
		end
		
		describe "when trying to view the users page" do
			before { visit users_path }

			# it shouldn't allow to go to users index page, and forward to root page instead
			it { should have_title('All surveys') }
		end
		
		describe "when trying a get index action" do
			before { get users_path }

			# it shouldn't allow to go to view profile page, and forward to sign in page instead
			specify { response.should redirect_to(root_url) }
		end
		
		# user already signed_in should not be able to signup (3 following tests)
		describe "when trying to sign-up again" do
			before { visit signup_path }

			it { should have_title('All surveys') }
		end
		describe "when trying a new action" do
			before { get signup_path }

			specify { response.should redirect_to(root_url) }
		end
		describe "when trying a create action" do
			before { post users_path }

			specify { response.should redirect_to(root_url) }
		end
		
		describe "in the Surveys controller" do
			let(:survey) { FactoryGirl.create(:survey, user: wrong_user, title: "Survey 1") }

			describe "when trying to view a survey" do
				before { visit survey_path(survey) }

				it { should have_title('All surveys') }
			end

			describe "when trying a show action on a survey" do
				before { get survey_path(survey)  }

				specify { response.should redirect_to(root_url) }
			end

			describe "when trying to edit a survey" do
				describe "visiting the edit survey page" do
					before { visit edit_survey_path(survey) }
					it { should have_title('All surveys') }
				end

				describe "submitting to the update action" do
					before { put survey_path(survey) }
					specify { response.should redirect_to(root_url) }
				end
			end

			describe "when submitting a DELETE request to the Surveys#destroy action" do
				before { delete survey_path(survey) }
				specify { response.should redirect_to(root_url) }        
			end
		end

		describe "in the Questions controller" do
			let(:survey) { FactoryGirl.create(:survey, user: wrong_user, title: "Survey 1") }
			let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }

			describe "when trying to view a question" do
				before do
					visit edit_survey_path(survey)
					visit question_path(question)
				end

				it { should have_title('All surveys') }
			end

			describe "when trying a show action on a question" do
				before do
					visit edit_survey_path(survey)
					get question_path(question)
				end

				specify { response.should redirect_to(root_url) }
			end

			describe "when trying to edit a question" do
				describe "visiting the edit question page" do
					before do
						visit edit_survey_path(survey)
						visit edit_question_path(question)
					end
					it { should have_title('All surveys') }
				end

				describe "submitting to the update action" do
					before do
						visit edit_survey_path(survey)
						put question_path(question)
					end
					specify { response.should redirect_to(root_url) }
				end
			end

			describe "when submitting a DELETE request to the Questions#destroy action" do
				before do
					visit edit_survey_path(survey)
					delete question_path(question)
				end
				specify { response.should redirect_to(root_url) }        
			end
		end

		describe "in the Answers controller" do

			describe "when trying to edit an answer" do
				let(:survey) { FactoryGirl.create(:survey, user: wrong_user, title: "Survey 1") }
				let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
				let(:answer) { FactoryGirl.create(:answer, question: question, user: wrong_user, choice: 3) }

				describe "visiting the edit answer page" do
					before { visit edit_answer_path(answer) }
					it { should have_title('All surveys') }
				end

				describe "submitting to the update action" do
					before { put answer_path(answer) }
					specify { response.should redirect_to(root_url) }
				end
			end
		end

		describe "when trying to see results" do
			let(:survey) { FactoryGirl.create(:survey, user: wrong_user, title: "Survey 1", available: true) }
			let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
			let(:answer) { FactoryGirl.create(:answer, question: question, user: wrong_user, choice: 3) }

			describe "the survey results" do
				before { visit results_survey_path(survey) }
				it { should have_title('All surveys') }
			end

			describe "the survey results" do
				before { visit results_question_path(question) }
				it { should have_title('All surveys') }
			end
		end
	end

	# when a non-signed-in user try to view or edit profile, he's redirected
	# to sign-in page. If he signed-in correctly, he should then be redirected
	# again to the page he has originaly asked for.
	describe "when reforwarding," do
		describe "for non-signed-in users" do
			let(:sign_in_button) {'Sign in'}
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to view a profile" do
				before do
					visit user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button sign_in_button
				end

				describe "after signing in" do
					it "should render the view profile page" do
						page.should have_title(user.name)
					end
				end
			end

			describe "when attempting to edit a profile" do
				before do
					visit edit_user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button sign_in_button
				end

				describe "after signing in" do
					it "should render the edit profile page" do
						page.should have_title('Update profile')
					end

					describe "when signin again" do
						before { sign_in(user) }

						it "should render the view profile page" do
							page.should have_title('All surveys')
						end
					end
				end
			end
		end
	end
	
	describe "As non-admin user" do
		let(:user)      { FactoryGirl.create(:user) }
		let(:non_admin) { FactoryGirl.create(:user) }

		before { sign_in non_admin }

		describe "when submitting a DELETE request to the Users#destroy action" do
			before { delete user_path(user) }
			specify { response.should redirect_to(root_url) }        
		end
	end
	
	describe "As a admin user" do
		let(:admin) { FactoryGirl.create(:admin) }

		before do
			sign_in admin
			visit root_path
		end

		it { should have_link('Users', href: users_path) }
	end
end

