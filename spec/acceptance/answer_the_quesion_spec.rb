require 'rails_helper'

feature 'Answer the question', %q{
  In order to help other user
  As an authorizesed user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authorizesed user answers the question' do
    sign_in(user)

    visit question_path question

    click_on 'Add Answer'
    fill_in 'answer_body', with: 'my answer text'

    click_on 'Create Answer'

    expect(page).to have_content 'Your answer successfully saved.'
  end

  scenario 'Non-authorizesed user tries to creates question' do
    visit question_path question

    click_on 'Add Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

