require 'spec_helper'

describe "Regarding all answer pages :" do
	subject { page }

	shared_examples_for "all answer pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end

	describe "When testing title and h1 on new page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }
		let!(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
		let!(:another_question) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }

		before do
			sign_in user
			visit begin_survey_path(survey)
			visit new_answer_path
		end
		
		let(:heading) {survey.title}
		let(:page_title) {'Feedback question'}

		it_should_behave_like "all answer pages"

		describe "when filling fields on new page" do
			let(:create_answer_button) {'Save changes and next question'}

			describe "with invalid information," do
				it "should not create a answer" do
					expect { click_button create_answer_button }.not_to change(Answer, :count)
				end

				describe "should display error messages" do
					before do
						fill_in "Your choice", with: ""
						click_button create_answer_button
					end

					it { should have_flash_message('Choice must be between 1 and 5','error') } 
				end
			end

			describe " with valid information, " do
				before do
					fill_in "Your choice", with: 3
				end

				it "should create an answer" do
					expect do
						click_button create_answer_button
					end.to change(Answer, :count).by(1)
				end
			end
		end
	end

	describe "When testing title and h1 on edit page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }
		let!(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }
		let!(:another_question) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }
		let(:answer) { FactoryGirl.create(:answer, question: question, user: user) }

		before do
			sign_in user
			visit begin_survey_path(survey)
			visit edit_answer_path(answer)
		end
		
		let(:heading) {survey.title}
		let(:page_title) {'Feedback question'}

		it_should_behave_like "all answer pages"

		describe "when filling fields on edit page" do
			let(:save_answer_button) {'Save changes and next question'}

			describe "with invalid information," do

				describe "should display error messages" do
					before do
						fill_in "Your choice", with: 7
						click_button save_answer_button
					end

					it { should have_flash_message('Choice must be between 1 and 5','error') }
				end
			end

			describe " with valid information, " do
				before do
					fill_in "Your choice", with: "3"
					fill_in "Comment", with: "Fake fake fake"
					click_button save_answer_button
				end

				specify { answer.reload.choice.should == 3 }
				specify { answer.reload.comment.should == "Fake fake fake" }
			end
		end
	end
end
