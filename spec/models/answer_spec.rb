require 'spec_helper'

describe Answer do

	let(:user) { FactoryGirl.create(:user) }
	let(:survey) { FactoryGirl.create(:survey, user: user, title: "Survey 1") }
	let(:question) { FactoryGirl.create(:question, survey: survey, title: "Question 1") }

	before do
		@answer = question.answers.build(choice: 1, comment: "")
		@answer.user = user
	end

	subject { @answer }

	it { should respond_to(:question_id) }
	it { should respond_to(:user_id) }
	it { should respond_to(:choice) }
	it { should respond_to(:comment) }

  	# check that answer.question is valid
	it { should respond_to(:question) }
	its(:question) { should == question }

	# check that answer.user is valid
	it { should respond_to(:user) }
	its(:user) { should == user }

	it {should be_valid }

	describe "When question_id is not present" do
		before { @answer.question_id = nil }
		it { should_not be_valid }
	end

	describe "When user_id is not present" do
		before { @answer.user_id = nil }
		it { should_not be_valid }
	end

	describe "When choice is not present" do
		before { @answer.choice= nil }
		it { should_not be_valid }
	end

	describe "When choice is blank" do
		before { @answer.choice = " " }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to question_id" do
			expect do
				Answer.new(question_id: question.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end

		it "should not allow access to user_id" do
			expect do
				Answer.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
