FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Fake #{n}" }
		sequence(:email) { |n| "fake#{n}@fake.fake" } 
		password "fakefake"
		password_confirmation "fakefake"
		
		factory :admin do
			admin true
		end
	end

	factory :survey do
		sequence(:title)  { |n| "Survey #{n}" }
		user
	end

	factory :question do
		sequence(:title)  { |n| "Question #{n}" }
		survey
	end
end
