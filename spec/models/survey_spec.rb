require 'spec_helper'

describe Survey do

	let(:user) { FactoryGirl.create(:user) }
	before do
		@survey = user.surveys.build(title: "Survey 1")
	end

	subject { @survey }

	it { should respond_to(:title) }
	it { should respond_to(:key) }
	it { should respond_to(:user_id) }
	it { should respond_to(:anonymous) }
	it { should respond_to(:private) }
	it { should respond_to(:available) }
	it { should respond_to(:link) }

	it { should respond_to(:questions) }

  	# check that survey.user is valid
	it { should respond_to(:user) }
	its(:user) { should == user }

	it {should be_valid }

	describe "When user_id is not present" do
		before { @survey.user_id = nil }
		it { should_not be_valid }
	end

	describe "When title is not present" do
		before { @survey.title = nil }
		it { should_not be_valid }
	end

	describe "When title is blank" do
		before { @survey.title = " " }
		it { should_not be_valid }
	end

	describe "with available attribute set to 'true'" do
		before { @survey.toggle!(:available) }
		it { should be_available }
	end

	describe "with anonymous attribute set to 'true'" do
		before { @survey.toggle!(:anonymous) }
		it { should be_anonymous }
	end

	describe "with private attribute set to 'true'" do
		before { @survey.toggle!(:private) }
		it { should be_private }
	end

	describe "key token" do
		before { @survey.save }
		its(:key) {should_not be_blank}
		after { @survey.destroy }
	end


	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Survey.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "question associations" do
		before { @survey.save }

		let!(:older_question) { FactoryGirl.create(:question, survey: @survey) }
		let!(:newer_question) { FactoryGirl.create(:question, survey: @survey) }

		it "should destroy associated questions" do
			questions = @survey.questions
			@survey.destroy
			questions.each do |question|
				Question.find_by_id(question.id).should be_nil
			end
		end

		after { @survey.destroy }
	end
end

