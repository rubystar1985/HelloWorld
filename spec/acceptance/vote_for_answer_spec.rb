require_relative 'acceptance_helper'

feature 'Voting for answer', %q{
  In order to show my opinion about the answer
  As an authorized user
  I'd like to be able to vote for or against some answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthorized does not see links vote for nor for against answer' do
    visit question_path(question)

    within '.answer' do
      expect(page).not_to have_selector "input[type=submit][value='+1']"
      expect(page).not_to have_selector "input[type=submit][value='-1']"
      expect(page).to have_text 'Votes: 0'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see links vote for and for against answer' do
      within '.answer' do
        expect(page).to have_selector "input[type=submit][value='+1']"
        expect(page).to have_selector "input[type=submit][value='-1']"
        expect(page).to have_text 'Votes: 0'
      end
    end

    scenario 'vote for answer', js: true do
      within '.answer' do
        click_on '+1'
        expect(page).not_to have_selector "input[type=submit][value='+1']"
        expect(page).not_to have_selector "input[type=submit][value='-1']"
        expect(page).to have_text 'Votes: 1'
      end
    end
  end

  describe 'Another user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario "Authenticated user votes for other user's answer", js: true do
      within '.answer' do
        click_on '+1'
        expect(page).not_to have_link '+1'
        expect(page).not_to have_link '-1'
        expect(page).to have_text 'Votes: 1'
      end
    end
  end
end
