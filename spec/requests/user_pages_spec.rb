require 'spec_helper'

describe "User pages"  do
	subject { page }

	#pages
	describe "signup page"  do
		before { visit signup_path }
		it { should have_selector('title', text: full_title('Sign up') )}
		it { should have_selector('h1', text: "Sign up") }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit user_path(user)}
		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name)}
	end

	#actions

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
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
			end
			before { click_button "Sign in" }
			it { should have_selector('title', text: user.name) }
			it { should have_link("Sign out") }
			it { should_not have_link("Sign in") }
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user) 
		end
		describe "page" do
			it { should have_selector('h1', text: "Update your profile") }
			it { should have_selector('title', text: "Edit user") }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do
			before { click_button "Save changes" }
			it { should have_content('error') }
		end

		describe "with valid information" do
			# let(:user) { FactoryGirl.create(:user) }
			# before { sign_in user }
			it { should have_selector('title', text: "Edit user") }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sing in', href: signin_path) }
		end

		describe "should change password succesfully" do
			# let(:user) { FactoryGirl.create(:user) }
			before do
				# sign_in user
				# visit edit_user_path(user)
				fill_in "Name", with: user.name
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end
			it { should have_content('successfully') }
			# signed_in_form
			it { should have_link('Profile', href:user_path(user)) }
			it { should have_link('Settings', href:edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link("Sign in", href: signin_path) }
		end

		describe "should change username + email successfully" do
			# let(:user) { FactoryGirl.create(:user) }
			let(:new_name) { "new user name"}
			let(:new_email) { "newemail@gmail.com" }
			before do
				# visit edit_user_path(user)
				fill_in "Name", with: new_name
				fill_in "Email", with: new_email
				fill_in "Password", with: user.password
				fill_in "Confirm Password", with:user.password
				click_button "Save changes"
			end
			it { should have_content('successfully') }
			it { should have_link('Profile', href:user_path(user)) }
			it { should have_link('Settings', href:edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should have_selector('title', text: new_name) }
			it { should_not have_link("Sign in", href: signin_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end

	describe "index" do
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob", email: "bob@gmail.com" )
			FactoryGirl.create(:user, name: "Ben", email: "ben@gmail.com")
			visit users_path
		end

		it { should have_selector('title', text: "All users") }
		it "should list each user" do
			User.all.each do |user|
				page.should have_selector('li', text: user.name)
			end
		end

		describe "delete link" do
			it { should_not have_link('delete') }

			describe "as an admin user" do
				#create an admin user
				let(:user_admin) { FactoryGirl.create(:admin) }
				before do
					sign_in user_admin
					visit users_path
				end
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete').to change(User, :count).by(-1) }
				end
				it { should_not have_link('delete', href: user_path(user_admin)) }
			end
		end
	end
end
