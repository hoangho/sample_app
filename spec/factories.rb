FactoryGirl.define  do
	factory :user do
		sequence(:name) { |n| "user#{n}" }
		sequence(:email) { |n| "user#{n}@gmail.com" }
		password "thaihoang"
		password_confirmation "thaihoang"

		factory :admin do
			admin true
		end
	end
end