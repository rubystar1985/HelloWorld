require 'rails_helper'

feature 'Browse question and its answer', %q{
  In order to solve the problem
  As an user
  I want to be able to browse the question and answer to it
} do

  given(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  scenario 'Authorizesed user browses question and its answer' do
    sign_in(user)

    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers.first.body
  end

  scenario 'Non-authorizesed user browses question and its answer' do
    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers.first.body
  end
end
