def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def fillin_sample_user_info
       fill_in "Name",         with: "Example User"
       fill_in "Email",        with: "user@example.com"
       fill_in "Password",     with: "foobar"
       fill_in "Confirm Password", with: "foobar"
end

def fillin_with_name_and_email(name, email)
	visit signup_path
    fill_in "Name",         with: name
    fill_in "Email",        with: email
    fill_in "Password",     with: "foobar"
    fill_in "Confirm Password", with: "foobar"
    click_button submit
    click_link "Sign out"
end