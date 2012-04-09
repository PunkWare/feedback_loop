require 'spec_helper'

describe Question do

	let(:user) { FactoryGirl.create(:user) }
	let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
	before do
		@question = survey.questions.build(title: "Question 1")
	end

	subject { @question }

	it { should respond_to(:survey_id) }
	it { should respond_to(:title) }
	it { should respond_to(:number_of_choices) }
	it { should respond_to(:low_choice) }
	it { should respond_to(:high_choice) }

  	# check that survey.user is valid
	it { should respond_to(:survey) }
	its(:survey) { should == survey }

	it {should be_valid }

	describe "When survey_id is not present" do
		before { @question.survey_id = nil }
		it { should_not be_valid }
	end

	describe "When title is not present" do
		before { @question.title = nil }
		it { should_not be_valid }
	end

	describe "When title is blank" do
		before { @question.title = " " }
		it { should_not be_valid }
	end

	describe "When low choice is not present" do
		before { @question.low_choice = nil }
		it { should_not be_valid }
	end

	describe "When low choice is blank" do
		before { @question.low_choice = " " }
		it { should_not be_valid }
	end

	describe "When high choice is not present" do
		before { @question.high_choice = nil }
		it { should_not be_valid }
	end

	describe "When high choice is blank" do
		before { @question.high_choice = " " }
		it { should_not be_valid }
	end

	describe "When number of choices is not present" do
		before { @question.number_of_choices = nil }
		it { should_not be_valid }
	end

	describe "When remaining effort is blank" do
		before { @question.number_of_choices = " " }
		it { should_not be_valid }
	end

	describe "when remaining  effort format is invalid" do
		invalid_formats =  %w[-1 +1 1.0 1,0 a 1e5 ]
		invalid_formats.each do |invalid_format|
			before { @question.number_of_choices = invalid_format}
			it { should_not be_valid }
		end
	end

	describe "when remaining effort format is valid" do
		valid_formats = %w[ 1 1456 ]
		valid_formats.each do |valid_format|
			before { @question.number_of_choices = valid_format }
			it { should be_valid }
		end
	end

	describe "accessible attributes" do
		it "should not allow access to survey_id" do
			expect do
				Question.new(survey_id: survey.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
