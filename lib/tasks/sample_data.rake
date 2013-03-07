namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example user", email: "example@gmail.com", password: "thaihoang", password_confirmation: "thaihoang")
		admin.toggle!(:admin)
	end
end