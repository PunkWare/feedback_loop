require 'spec_helper'

describe Answer do

	let(:user) { FactoryGirl.create(:user) }
	let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }

	before do
		@access = survey.accesses.build()
		@access.user = user
	end

	subject { @access }

	it { should respond_to(:survey_id) }
	it { should respond_to(:user_id) }

  	# check that access.survey is valid
	it { should respond_to(:survey) }
	its(:survey) { should == survey }

	# check that access.user is valid
	it { should respond_to(:user) }
	its(:user) { should == user }

	it {should be_valid }

	describe "when there's already an user / survey association" do
		before do
			# duplicate the access and save it in the test database db/test.sqlite3
			another_access_for_same_user_and_same_survey = @access.dup
			another_access_for_same_user_and_same_survey.save
		end
		
		it { should_not be_valid }
	end

	describe "When survey_id is not present" do
		before { @access.survey_id = nil }
		it { should_not be_valid }
	end

	describe "When user_id is not present" do
		before { @access.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to question_id" do
			expect do
				Access.new(survey_id: survey.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end

		it "should not allow access to user_id" do
			expect do
				Access.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
