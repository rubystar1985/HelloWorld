require 'rails_helper'

feature 'Delete question', %q{
  In order to remove wrong question
  As an authorizesed user
  I want to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:other_user_question) { create(:question, user: other_user) }


  scenario 'Authorizesed user deletes his own question' do
    sign_in(user)

    visit question_path question
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario "Authorizesed user tries to deletes other user's question" do
    sign_in(user)

    visit question_path other_user_question

    expect(page).not_to have_content 'Delete question'
  end

  scenario 'Non-authorizesed user tries to deletes question' do
    visit question_path question

    expect(page).not_to have_content 'Delete question'
  end
end

