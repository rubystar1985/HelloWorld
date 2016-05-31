require_relative 'acceptance_helper'

feature 'Voting for question', %q{
  In order to show my opinion about the question
  As an authorized user
  I'd like to be able to vote for or against some question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthorized does not see links vote for nor for against question' do
    visit question_path(question)

    expect(page).not_to have_selector "input[type=submit][value='+1']"
    expect(page).not_to have_selector "input[type=submit][value='-1']"
    expect(page).to have_text 'Votes: 0'
  end

  describe 'Authenticated user tries to vote for his own question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'does not see links vote for and for against question' do
      expect(page).not_to have_selector "input[type=submit][value='+1']"
      expect(page).not_to have_selector "input[type=submit][value='-1']"
      expect(page).to have_text 'Votes: 0'
    end
  end

  describe 'Another user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'sees vote for question buttons', js: true do
      click_on '+1'

      expect(page).to have_selector "input[type=submit][value='+1']"
      expect(page).to have_selector "input[type=submit][value='-1']"
      expect(page).to have_text 'Votes: 1'
    end

    scenario "Authenticated user votes for other user's question", js: true do
      click_on '+1'

      expect(page).not_to have_link '+1'
      expect(page).not_to have_link '-1'
      expect(page).to have_text 'Votes: 1'
    end
  end
end
