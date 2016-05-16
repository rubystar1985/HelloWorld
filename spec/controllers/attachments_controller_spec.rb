require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    describe 'not authorized user' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user_id: user.id) }
      let(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      describe 'delete attachment from question' do
        it 'deletes attachment from question' do
          expect { delete :destroy, question_id: question, id: attachment, format: :js }.not_to change(Attachment, :count)
        end
      end

      describe 'delete attachment from answer' do
        it 'deletes attachment from answer' do
          expect { delete :destroy, question_id: question, answer_id: answer, id: attachment, format: :js }.not_to change(Attachment, :count)
        end
      end
    end

    describe 'authorized user' do
      sign_in_user
      let(:question) { create(:question, user_id: @user.id) }
      let!(:attachment) { create(:attachment, attachable: question) }

      describe 'delete attachment from question' do
        context 'deletes his own attachment from question' do
          it 'deletes attachment' do
            expect { delete :destroy, question_id: question, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
          end

          it 'assigns the requested attachment to @attachment' do
            delete :destroy, question_id: question, id: attachment, format: :js
            expect(assigns(:attachment)).to eq attachment
          end
        end

        context "deletes attachment from other user's question" do
          let!(:other_user) { create(:user) }
          let!(:other_user_question) { create(:question, user_id: other_user.id) }
          let!(:other_attachment) { create(:attachment, attachable: other_user_question) }

          it 'deletes attachment from question' do
            expect { delete :destroy, question_id: other_user_question, id: other_attachment, format: :js }.not_to change(Attachment, :count)
          end
        end
      end

      describe 'delete attachment from answer' do
        let(:answer) { create(:answer, question: question, user: @user) }
        let!(:attachment) { create(:attachment, attachable: answer) }

        context 'deletes his own attachment from answer' do
          it 'deletes attachment' do
            expect { delete :destroy, question_id: question, answer_id: answer, id: attachment, format: :js }.to change(answer.attachments, :count).by(-1)
          end

          it 'assigns the requested attachment to @attachment' do
            delete :destroy, question_id: question, answer_id: answer, id: attachment, format: :js
            expect(assigns(:attachment)).to eq attachment
          end
        end

        context "deletes attachment from other user's answer" do
          let!(:other_user) { create(:user) }
          let(:other_user_answer) { create(:answer, question: question, user: other_user) }
          let!(:other_attachment) { create(:attachment, attachable: other_user_answer) }

          it 'deletes attachment from answer' do
            expect { delete :destroy, question_id: question, answer_id: other_user_answer, id: other_attachment, format: :js }.not_to change(Attachment, :count)
          end
        end
      end
    end
  end
end
