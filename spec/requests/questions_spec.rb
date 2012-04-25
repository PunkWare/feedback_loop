require 'spec_helper'

describe "Regarding all question pages :" do
	subject { page }

	shared_examples_for "all question pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end

	describe "When testing title and h1 on new page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }

		before do
			sign_in user
			visit survey_path(survey)
			visit new_question_path
		end
		
		let(:heading) {'New question'}
		let(:page_title) {heading}

		it_should_behave_like "all question pages"

		describe "when filling fields on new page" do
			let(:create_question_button) {'Create question'}

			describe "with invalid information," do
				it "should not create a question" do
					expect { click_button create_question_button }.not_to change(Question, :count)
				end

				describe "should display error messages" do
					before do
						fill_in "Number of choices", with: ""
						fill_in "Text for first choice", with: ""
						fill_in "Text for last choice", with: ""
						click_button create_question_button
					end

					it { should have_flash_message('Title can\'t be blank','error') } 
					it { should have_flash_message('First choice can\'t be blank','error') } 
					it { should have_flash_message('Last choice can\'t be blank','error') }
					it { should have_flash_message('Number of choices is not a number','error') }
				end
			end

			describe " with valid information, " do
				before do
					fill_in "Title", with: "fake"
				end

				it "should create a question" do
					expect do
						click_button create_question_button
					end.to change(Question, :count).by(1)
				end

				describe "after saving the question" do
					let(:question) { Question.find_by_title('fake') }
					before { click_button create_question_button }      

					it { should have_title('Manage questions') }
					it { should have_flash_message('Question created','success') }
				end
			end
		end
	end

	describe "When testing title and h1 on view page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
		
		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit survey_path(survey)
			visit question_path(question)
		end
		
		let(:heading) {question.title}
		let(:page_title) {'Show question'}
		
		it_should_behave_like "all question pages"
		it { should have_link('Back to survey', href: survey_path(survey)) }
	end

	describe "When testing title and h1 on edit page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }

		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit survey_path(survey)
			visit edit_question_path(question)
		end

		let(:heading) {'Update question'}
		let(:page_title) {heading}
		
		it_should_behave_like "all question pages"
	end

	describe "When providing edit fields" do
		let(:save_profile_button) {'Save changes'}
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
		let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
		
		# must sign in user to comply with authorization restrictions
		before do
			sign_in user
			visit survey_path(survey)
			visit edit_question_path(question)
		end

		describe "with invalid information," do

			describe "should display error messages" do

				# by default the two fields are already filled with user's information
				# they are emptied so that errors messages can be checked
				before do
					fill_in "Title", with: ""
					fill_in "Number of choices", with: ""
					fill_in "Text for first choice", with: ""
					fill_in "Text for last choice", with: ""
					click_button save_profile_button
				end
				
				it { should have_flash_message('Title can\'t be blank','error') }
				it { should have_flash_message('First choice can\'t be blank','error') } 
				it { should have_flash_message('Last choice can\'t be blank','error') }
				it { should have_flash_message('Number of choices is not a number','error') }
			end
		end

		describe " with valid information, " do
			let(:updated_title)	{ "title updated" }
			let(:updated_link)	{ "http://www.github.com/punkware" }

			before do
				fill_in "Title",						with: updated_title
				fill_in "Number of choices",		with: "8"
				fill_in "Text for first choice",	with: "Never"
				fill_in "Text for last choice",	with: "Always"
				fill_in "Link",						with: updated_link
				click_button save_profile_button
			end

			it { should have_flash_message('Question updated','success') }
			it { should have_title(full_title('Manage questions')) }

			# Check that the data have been indeed modified
			specify { question.reload.title.should == updated_title }
			specify { question.reload.number_of_choices.should == 8 }
			specify { question.reload.first_choice.should == "Never" }
			specify { question.reload.last_choice.should == "Always" }
			specify { question.reload.link.should == updated_link }
		end
	end

	describe "When deleting questions of a survey" do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }
		let!(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
		let!(:another_question) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }


		before do
			sign_in user
			visit survey_path(survey)
			click_link('delete')
		end

		it { should_not have_flash_message("This question was the last of the survey. As a result, the survey is not available for feedback anymore.",'notice') }
		specify { survey.reload.available.should == true }

		describe ", deleting last one" do
			before do
				click_link('delete')
			end

			it { should have_flash_message("This question was the last of the survey. As a result, the survey is not available for feedback anymore.",'notice') }
			specify { another_question.survey.reload.available.should == false }
		end
	end
end