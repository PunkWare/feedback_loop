require 'spec_helper'

describe "Regarding all access pages :" do
	
	subject { page }

	shared_examples_for "all access pages" do
		it { should have_title(full_title(page_title)) }
		it { should have_heading(heading) }
	end

	describe "When displaying new page, " do
		let(:user) { FactoryGirl.create(:user) }
		let!(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1", available: true) }

		let(:heading) {'Join private survey'}
		let(:page_title) {heading}
		let(:create_access_button) {'Join'}

		before do
			sign_in user
			visit new_access_path
		end

		it { should have_button(create_access_button) }

		it_should_behave_like "all access pages"

		describe "when filling fields on new page" do

			describe "with invalid information," do
				it "should not create an access" do
					expect { click_button create_access_button }.not_to change(Access, :count)
				end
			
				describe "should display error messages" do
					before do
						fill_in "Key", with: "fake"
						click_button create_access_button
					end
			
					it { should have_flash_message('The key you entered is not valid.','error') } 
				end
			end

			describe "with key for survey that is already joined" do
				let!(:access) { FactoryGirl.create(:access, user: user, survey: survey) }
			
				describe "should display error messages" do
					before do
						fill_in "Key", with: survey.key
						click_button create_access_button
					end
			
					it { should have_flash_message('You have joined this survey already.','alert') } 
				end
			end

			describe " with valid information, " do
				before do
					fill_in "Key", with: survey.key
				end

				it "should create an access" do
					expect do
						click_button create_access_button
					end.to change(Access, :count).by(1)
				end

				describe "after joining, " do
					before { click_button create_access_button }
					
					it { should have_title(full_title('All surveys')) }
				end   
			end
		end
	end
end
