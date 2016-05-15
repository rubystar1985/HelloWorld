require_relative 'acceptance_helper'

feature 'Remove file from answer', %q{
  In order to remove file attached to my answer
  As a answer's author
  I'd like to be able to delete attachment from answer
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment) { create(:attachment, attachable: answer) }
  given(:other_user) { create(:user) }

  scenario 'Authorizesed user deletes his attachment', js: true do
    sign_in(user)
    visit question_path question

    expect(page).to have_css '.b-delete-attachment'
    click_on 'Delete attachment'

    expect(page).not_to have_text 'acceptance_helper.rb'
  end

  scenario 'Not authorizesed user deletes attachment', js: true do
    visit question_path question

    expect(page).not_to have_css '.b-delete-attachment'
  end

  scenario 'Another authorizesed user deletes attachment', js: true do
    sign_in(other_user)
    visit question_path question

    expect(page).not_to have_css '.b-delete-attachment'
  end
end
