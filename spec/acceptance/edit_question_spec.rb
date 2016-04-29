require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthorized user try to edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit question'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit question' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit question'

      fill_in 'New question title', with: 'edited question title'
      fill_in 'New question body', with: 'edited question body'

      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body

      expect(page).to have_content 'edited question title'
      expect(page).to have_content 'edited question body'
      expect(page).to_not have_selector '.question textarea'
    end
  end

  describe 'Another user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario "Authenticated user try to edit other user's question" do
      expect(page).not_to have_link 'Edit question'
    end
  end
end
