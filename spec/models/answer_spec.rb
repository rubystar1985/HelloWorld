require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many :attachments }
  it { should have_many :votes }

  it { should accept_nested_attributes_for :attachments}

  describe '#set_best' do
    let(:question) { create(:question) }
    let!(:answer_first) { create(:answer, question: question) }

    context 'when best answer not selected' do
      let!(:answer_second) { create(:answer, question: question) }

      subject { answer_first.set_best }

      it 'changes is_best option to true for 1st answer' do
        expect { subject }.to change{ answer_first.is_best }.from(false).to(true)
      end

      it 'does not change is_best option for 2nd answer' do
        expect { subject }.not_to change{ answer_second.reload.is_best }
      end
    end

    context 'when best answer selected' do
      let!(:answer_second) { create(:answer, question: question, is_best: true) }

      subject { answer_first.set_best }

      it 'changes is_best option to true for 1st answer' do
        expect { subject }.to change{ answer_first.is_best }.from(false).to(true)
      end

      it 'changes is_best option to false for 2st answer' do
        expect { subject }.to change{ answer_second.reload.is_best }.from(true).to(false)
      end
    end
  end
end
