require 'rails_helper'

feature 'Browse questions list', %q{
  In order to find existing question
  As an user
  I want to be able to browse questions list
} do

  given(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  scenario 'Authorizesed user browses questions list' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'Questions list'
    expect(page).to have_content 'Ask question'
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'Non-authorizesed user browses questions list' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    expect(page).to have_content 'Ask question'
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end

