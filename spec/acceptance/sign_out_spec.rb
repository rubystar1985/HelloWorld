require_relative 'acceptance_helper'

feature 'User sign out', %q{
  In order to stop the session
  As an registered user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path

    expect(page).to have_content 'Logout'
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end

end
