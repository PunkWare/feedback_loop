require 'spec_helper'

describe "info_pages" do
	subject { page }
	
	shared_examples_for "all static pages" do
		it { should have_title(full_title(page_title)) }   
		it { should have_heading(heading) }
	end
	
	let(:home_page_title) {"Home"}
	let(:about_page_title) {"About"}
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
			after(:all)  { User.delete_all }

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
				let!(:survey11) { FactoryGirl.create(:survey, user: user, title: "Survey 1 from user") }
				let!(:survey12) { FactoryGirl.create(:survey, user: user, title: "Survey 2 from user", private: true ) }
				let!(:survey13) { FactoryGirl.create(:survey, user: user, title: "Survey 3 from user") }
				let!(:survey21) { FactoryGirl.create(:survey, user: another_user, title: "Survey 1 from another user") }
				let!(:survey22) { FactoryGirl.create(:survey, user: another_user, title: "Survey 2 from another user") }
				let!(:survey23) { FactoryGirl.create(:survey, user: another_user, title: "Survey 3 from another user", closed: true) }

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

				describe "pagination" do
					before(:all) do
						15.times { FactoryGirl.create(:survey, user: user) }
						15.times { FactoryGirl.create(:survey, user: another_user) }
					end
					after(:all)  { Survey.delete_all }

					let(:first_page)  { Survey.paginate(page: 1) }
					let(:second_page) { Survey.paginate(page: 2) }

					it { should have_link('Next') }
					it { should have_link('2') }

					it "should list each survey" do
						Survey.all[0..2].each do |survey|
							page.should have_selector('li', text: survey.title)
						end
					end

					it "should list the first page of surveys" do
						first_page.each do |survey|
							page.should have_selector('li', text: survey.title)
						end
					end

					it "should not list the second page of surveys" do
						second_page.each do |survey|
							page.should_not have_selector('li', text: survey.title)
						end
					end

					describe "showing the second page" do
						before { visit users_path(page: 2) }

						it "should list the second page of surveys" do
							second_page.each do |survey|
								page.should have_selector('li', text: survey.title)
							end
						end
					end
				end
				
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
	
	describe "about page" do
		before { visit about_path }
		let(:page_title) {about_page_title}
		let(:heading) {about_page_title}  
			
		it_should_behave_like "all static pages"
	end
	

	it "should have the right links on the layout" do
		visit root_path
		
		click_link "About"
		page.should have_title(full_title(about_page_title))
		
		click_link "Help"
		page.should have_title(full_title(help_page_title))
		
		click_link "Home"
		page.should have_title(full_title(home_page_title))
		
		click_link "Sign up now!"
		page.should have_title(full_title('Sign up'))
		
	end
	
end
