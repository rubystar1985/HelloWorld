require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthorized user try to edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
      end

      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector '.answers textarea'
    end

    scenario "Authenticated user try to edit other user's answer" do

    end
  end
end
