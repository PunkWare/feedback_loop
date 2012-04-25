require 'spec_helper'

describe "info_pages" do
	subject { page }
	
	shared_examples_for "all static pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end
	
	let(:home_page_title) {"Home"}
	let(:contact_page_title) {"Contact"}
	let(:help_page_title) {"Help"}
	
	describe "home page" do
		describe "for non-signed-in users" do
			before { visit root_path }
			let(:page_title) {home_page_title}
			let(:heading) {'Feedback Loop'}  
		
			it_should_behave_like "all static pages"
		end

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			let(:another_user) { FactoryGirl.create(:user) }

			before do
				sign_in user
				visit root_path
			end

			let(:page_title) {'All surveys'}
			let(:heading) {''}  
		
			it_should_behave_like "all static pages"
			it { should have_link('Join private survey', href: root_path) }
			#TO BE TESTED
			#describe "when clicking the new survey button" do
				#before { click_link 'Answer survey' }
				
				#it { should have_title('Feedback survey') }
			#end

			describe "as a signed-in user," do
				let!(:survey11) { FactoryGirl.create(:survey, user: user, title: "Survey 1 from user", available: true) }
				let!(:survey12) { FactoryGirl.create(:survey, user: user, title: "Survey 2 from user", private: true ) }
				let!(:survey13) { FactoryGirl.create(:survey, user: user, title: "Survey 3 from user", available: true) }
				let!(:survey21) { FactoryGirl.create(:survey, user: another_user, title: "Survey 1 from another user", available: true) }
				let!(:survey22) { FactoryGirl.create(:survey, user: another_user, title: "Survey 2 from another user", available: true) }
				let!(:survey23) { FactoryGirl.create(:survey, user: another_user, title: "Survey 3 from another user") }

				before do
					visit root_path
				end
				
				describe "the surveys" do
					it { should have_content(survey11.title) }
					it { should have_content(survey13.title) }
					it { should have_content(survey21.title) }
					it { should have_content(survey22.title) }

					it { should_not have_content(survey12.title) }
					it { should_not have_content(survey23.title) }
				end
				
				it { should have_link('Manage my surveys', href: user_surveys_path) }
				it { should have_link('Join private survey', href: root_path) }

				it { should_not have_link('delete', href: survey_path(Survey.first)) }

			end
		end
	end
	
	describe "help page" do
		before { visit help_path }
		let(:page_title) {help_page_title}
		let(:heading) {help_page_title} 
		
		it_should_behave_like "all static pages"
	end
	
	describe "contact page" do
		before { visit contact_path }
		let(:page_title) {contact_page_title}
		let(:heading) {contact_page_title}  
			
		it_should_behave_like "all static pages"
	end
	

	it "should have the right links on the layout" do
		visit root_path
		
		click_link "Contact"
		page.should have_title(full_title(contact_page_title))
		
		click_link "Help"
		page.should have_title(full_title(help_page_title))
		
		click_link "Home"
		page.should have_title(full_title(home_page_title))
		
		click_link "Sign up now!"
		page.should have_title(full_title('Sign up'))
		
	end

	describe "end page" do
		before { visit end_path }
		let(:page_title) {'Give feedback'}
		let(:heading) {'Thank you!'}  
			
		it_should_behave_like "all static pages"
		it { should have_link('Back to home page', href: root_path ) }
	end
	
end
