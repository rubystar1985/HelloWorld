require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to recomend some answer
  As an author of question
  I'd like to be able to set best answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthorized user try to set best answer' do
    visit question_path(question)

    expect(page).not_to have_css '.b-set-as-best'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees button to set best answer' do

      within '.answers' do
        expect(page).to have_css '.b-set-as-best'
      end
    end

    scenario 'try to to set best answer', js: true do
      click_on 'Set as best answer'
      expect(page).not_to have_css '.b-set-as-best'
      expect(page).to have_content 'Best answer!'
    end
  end

  describe 'Another user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario "Authenticated user try to set best answer" do
      expect(page).not_to have_css '.b-set-as-best'
    end
  end
end
