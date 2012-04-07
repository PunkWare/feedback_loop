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
	it { should respond_to(:closed) }

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

	describe "with closed attribute set to 'true'" do
		before { @survey.toggle!(:closed) }
		it { should be_closed }
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
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Survey.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end

