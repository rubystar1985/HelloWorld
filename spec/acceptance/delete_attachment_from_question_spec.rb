require_relative 'acceptance_helper'

feature 'Remove file from question', %q{
  In order to remove file attached to my question
  As a question's author
  I'd like to be able to delete attachment from question
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }
  given(:other_user) { create(:user) }

  scenario 'Authorizesed user deletes his own answer', js: true do
    sign_in(user)
    visit question_path question
    expect(page).to have_css '.b-delete-attachment'

    click_on 'Delete attachment'

    expect(page).not_to have_text 'acceptance_helper.rb'
  end

  scenario 'Not authorizesed user deletes his own answer', js: true do
    visit question_path question

    expect(page).not_to have_css '.b-delete-attachment'
  end

  scenario 'Another authorizesed user deletes his own answer', js: true do
    sign_in(other_user)
    visit question_path question

    expect(page).not_to have_css '.b-delete-attachment'
  end
end
