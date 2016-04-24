require_relative 'acceptance_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated User
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question)}
  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authorizesed user tries to creates question' do
    visit question_path question
    fill_in 'answer_body', with: 'my answer text'
    click_on 'Create'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end
