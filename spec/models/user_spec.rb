require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }


  let(:author) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }

  it "author_of? returns true for author of answer" do
    expect(author.author_of?(answer)).to eq(true)
  end

  it "author_of? returns false for non-author of answer" do
    expect(non_author.author_of?(answer)).to eq(false)
  end
end
