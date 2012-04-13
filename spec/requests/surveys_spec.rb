require 'spec_helper'

describe "Regarding all survey pages :" do
	subject { page }

	shared_examples_for "all survey pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end

	describe "When testing title and h1 on new page, " do
		let(:user) { FactoryGirl.create(:user) }

		before do
			sign_in user
			visit new_survey_path
		end
		
		let(:heading) {'New survey'}
		let(:page_title) {heading}

		it_should_behave_like "all survey pages"

		describe "when filling fields on new page" do
			let(:create_survey_button) {'Create survey'}

			describe "with invalid information," do
				it "should not create a survey" do
					expect { click_button create_survey_button }.not_to change(Survey, :count)
				end

				describe "should display error messages" do
					before { click_button create_survey_button }

					it { should have_flash_message('Title can\'t be blank','error') }   
				end
			end

			describe " with valid information, " do
				before do
					fill_in "Title",         with: "fake"
				end

				it "should create a survey" do
					expect do
						click_button create_survey_button
					end.to change(Survey, :count).by(1)
				end

				describe "after saving the survey" do
					let(:survey) { Survey.find_by_title('fake') }
					before { click_button create_survey_button }      

					it { should have_title('My surveys') }
					it { should have_flash_message('Survey created','success') }
				end
			end
		end
	end

	describe "When testing title and h1 on view page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		
		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit survey_path(survey)
		end
		
		let(:heading) {'Manage questions'}
		let(:page_title) {heading}
		
		it_should_behave_like "all survey pages"
		it { should have_link('New question', href: root_path) }
	end

	describe "When testing title and h1 on edit page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }

		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit edit_survey_path(survey)
		end

		let(:heading) {'Update survey'}
		let(:page_title) {heading}
		
		it_should_behave_like "all survey pages"
	end

	describe "When providing edit fields" do
		let(:save_profile_button) {'Save changes'}
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		
		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit edit_survey_path(survey)
		end

		describe "with invalid information," do

			describe "should display error messages" do

				# by default the two fields are already filled with user's information
				# they are emptied so that errors messages can be checked
				before do
					fill_in "Title", with: ""
					click_button save_profile_button
				end
				
				it { should have_flash_message('Title can\'t be blank','error') }
			end
		end

		describe " with valid information, " do
			let(:updated_title) { "title updated" }

			before do
				fill_in "Title",        with: updated_title
				check('Anonymous')
				check('Private')
				check('Closed')
				click_button save_profile_button
			end

			it { should have_flash_message('Survey updated','success') }
			it { should have_title(full_title('My surveys')) }

			# Check that the data have been indeed modified
			specify { survey.reload.title.should == updated_title }
			specify { survey.reload.anonymous.should == true }
			specify { survey.reload.private.should == true }
			specify { survey.reload.closed.should == true }
		end
	end

	describe "When displaying survey's questions page" do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		let(:heading) {'Manage questions'}
		let(:page_title) {heading}

		# as a non signed-in user
		before do
			visit survey_path(survey)
		end

		it { should_not have_title(full_title(page_title)) }

		describe "as a signed-in user," do
			let!(:question1) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
			let!(:question2) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }
			
			before do
				sign_in user
				visit survey_path(survey)
			end
			
			it_should_behave_like "all survey pages"

			it { should have_link('New question', href: root_path) }

			describe "when clicking the new question button" do
				before { click_link 'New question' }
				
				it { should have_title('All surveys') }
			end
			
			describe "the questions" do
				it { should have_content(question1.title) }
			
				it { should have_content(question2.title) }

				it { should have_link('delete', href: question_path(Question.first)) }
			end
=begin
			describe "pagination" do
				before(:all) { 30.times { FactoryGirl.create(:question, survey: survey) } }
				after(:all)  { Question.delete_all }

				let(:first_page)  { Question.paginate(page: 1) }
				let(:second_page) { Question.paginate(page: 2) }

				it { should have_link('Next') }
				it { should have_link('2') }

				it "should list each question" do
					Question.all[0..2].each do |question|
						page.should have_selector('li', text: question.title)
					end
				end

				it "should list the first page of questions" do
					first_page.each do |question|
						page.should have_selector('li', text: question.title)
					end
				end

				it "should not list the second page of questions" do
					second_page.each do |question|
						page.should_not have_selector('li', text: question.title)
					end
				end

				describe "showing the second page" do
					before { visit survey_path(survey, page: 2) }

					it "should list the second page of questions" do
						second_page.each do |question|
							page.should have_selector('li', text: question.title)
						end
					end
				end
			end
=end			
			it "should be able to delete the question" do
				expect { click_link('delete') }.to change(Question, :count).by(-1)
			end
			
		end
	end
end