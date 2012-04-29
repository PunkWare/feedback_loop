require 'spec_helper'

describe "Regarding all answer pages :" do
	let(:updated_link)	{ "http://www.github.com/punkware" }

	subject { page }

	shared_examples_for "all answer pages" do
		it { should have_title(full_title(page_title)) }
		it { should have_heading(heading) }
	end

	describe "When testing title and h1 on new page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }
		let!(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1", link: updated_link) }
		let!(:another_question) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }

		before do
			sign_in user
			visit begin_survey_path(survey)
			visit new_answer_path
		end
		
		let(:heading) {survey.title}
		let(:page_title) {'Feedback question'}

		it { should_not have_link('Previous question') }
		it { should have_button('Save changes and next question') }
		it { should_not have_button('Save changes and finish' ) }
		it { should have_link('Additional information about the question available here.', href: updated_link) }

		it_should_behave_like "all answer pages"

		describe "when filling fields on new page" do
			let(:create_answer_button) {'Save changes and next question'}

			# The block below is obsolete as the choice is a select field : can't be blank or undefined 
			#describe "with invalid information," do
			#	it "should not create a answer" do
			#		expect { click_button create_answer_button }.not_to change(Answer, :count)
			#	end
			#
			#	describe "should display error messages" do
			#		before do
			#			fill_in "Your choice", with: ""
			#			click_button create_answer_button
			#		end
			#
			#		it { should have_flash_message('Choice must be between 1 and 5','error') } 
			#	end
			#end

			describe " with valid information, " do
				before do
					select '3', from: "Your choice"
				end

				it "should create an answer" do
					expect do
						click_button create_answer_button
					end.to change(Answer, :count).by(1)
				end

				describe "going to question after" do
					before do 
						select '3', from: "Your choice"
						click_button create_answer_button
					end

					it_should_behave_like "all answer pages"

					it "should display second question" do 
						#save_and_open_page

						should have_link('Previous question')
						should have_button('Save changes and finish')
						should_not have_button('Save changes and next question')
					end
				end			
			end
		end
	end

	describe "When testing title and h1 on edit page, " do
		let(:user) { FactoryGirl.create(:user) }
		let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }
		let!(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1", link: updated_link) }
		let!(:another_question) { FactoryGirl.create(:question, survey: survey, title: "Question 2") }
		let(:answer) { FactoryGirl.create(:answer, question: question, user: user) }

		before do
			sign_in user
			visit begin_survey_path(survey)
			visit edit_answer_path(answer)
		end
		
		let(:heading) {survey.title}
		let(:page_title) {'Feedback question'}

		it { should have_link('Additional information about the question available here.', href: updated_link) }

		it_should_behave_like "all answer pages"

		describe "when filling fields on edit page" do
			let(:save_answer_button) {'Save changes and next question'}

			# The block below is obsolete as the choice is a select field : can't be out of range
			# describe "with invalid information," do

			# 	describe "should display error messages" do
			# 		before do
			# 			select '7', from: "Your choice"
			# 			click_button save_answer_button
			# 		end

			# 		it { should have_flash_message('Choice must be between 1 and 5','error') }
			# 	end
			# end

			describe " with valid information, " do
				before do
					select '3', from: "Your choice"
					fill_in "Comment", with: "Fake fake fake"
					click_button save_answer_button
				end

				specify { answer.reload.choice.should == 3 }
				specify { answer.reload.comment.should == "Fake fake fake" }
			end
		end
	end
end
