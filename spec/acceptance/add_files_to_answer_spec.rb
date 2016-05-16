require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds two files when answer the question', js: true do
    fill_in 'answer_body', with: 'my answer text'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add an attachment'

    within '.b-file-input-new-attachments' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end

end
