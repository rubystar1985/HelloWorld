require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove wrong answer
  As an author
  I want to be able to delete my answer
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Authorizesed user deletes his own answer' do
    sign_in(user)

    visit question_path question

    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).not_to have_content answer.body
  end

  scenario "Authorizesed user tries to delete other user's answer" do
    sign_in(other_user)

    visit question_path question

    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'Non-authorizesed user tries to delete answer' do
    visit question_path question

    expect(page).not_to have_content 'Delete answer'
  end
end

