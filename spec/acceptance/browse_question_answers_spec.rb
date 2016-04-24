require_relative 'acceptance_helper'

feature 'Browse question and its answer', %q{
  In order to solve the problem
  As an user
  I want to be able to browse the question and answer to it
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let!(:answers) { create_list(:answer, 2, question: question, user_id: user.id) }

  scenario 'Authorizesed user browses question and its answer' do
    sign_in(user)

    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authorizesed user browses question and its answer' do
    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end

