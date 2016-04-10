require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  let(:author) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }

  it "author_of? returns true for author of answer" do
    author.author_of?(answer).should eql(true)
  end

  it "author_of? returns false for non-author of answer" do
    non_author.author_of?(answer).should eql(false)
  end
end
