require 'spec_helper'
def full_title(page_title)
	base_title = "sample app"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	#Sign in when not using Capybara as well
	cookies[:remember_token] = user.remember_token
end

def signed_in_form
	# it { should have_link('Profile', href:user_path(user)) }
	# it { should have_link('Settings', href:edit_user_path(user)) }
	it { should have_link('Sign out failed', href: signout_path) }
	it { should_not have_link("Sign in", href: signin_path) }
end

def signed_in_form(user)
	it { should have_link('Profile', href:user_path(user)) }
	it { should have_link('Settings', href:edit_user_path(user)) }
	it { should have_link('Sign out', href: signout_path) }
	it { should_not have_link("Sign in", href: signin_path) }
end