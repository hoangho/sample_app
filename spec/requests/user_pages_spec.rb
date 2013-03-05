require 'spec_helper'

describe "User pages"  do
	subject { page }

	describe "signup page"  do
		before { visit signup_path }
		it { should have_selector('title', text: full_title('Sign up') )}
		it { should have_selector('h1', text: "Sign up") }
	end

	describe "signup" do
		before { visit signup_path }
		let(:submit) { "Create my account" } 

		describe "with invalid infor" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid infor" do
			before do
				fill_in "Name", with: "Auto example user"
				fill_in "Email", with: "auto.example.user@gmail.com"
				fill_in "Your password:", with: "thaihoang"
				fill_in "Confirmation password:", with: "thaihoang"
			end
			it "should creat a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit user_path(user)}
		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name)}
	end

	describe "signin" do
		before { visit signin_path }
		describe "with invalid information" do
			before { click_button "Sign in" }
			it { should have_selector('title', text: "Sign in") }
			it { should have_selector('div.alert.alert-error')}

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { User.all.first }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: "thaihoang"
			end
			before { click_button "Sign in" }
			it { should have_selector('title', user.name) }
			it { should have_link("Sign out") }
			it { should_not have_link("Sign in") }
		end
	end
end
