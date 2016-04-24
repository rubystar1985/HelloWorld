require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authorizesed user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authorizesed user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authorizesed user tries to creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

