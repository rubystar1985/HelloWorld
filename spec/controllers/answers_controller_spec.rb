require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let (:answer) { build :answer, question_id: question }
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: answer.attributes }.to change(Answer.where(question_id: question.id, user_id: @user.id), :count).by(1)
      end
      it 'redirect to show view' do
      post :create, question_id: question, answer: answer.attributes
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let (:answer) { build :invalid_answer, question_id: question.id }
        it 'does not save the answer' do
        expect { post :create, question_id: question, answer: answer.attributes }.to_not change(Answer, :count)
      end
      it 're-redirect new view' do
        post :create, question_id: question, answer: answer.attributes
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) { create(:answer, question_id: question.id, user_id: @user.id) }

    context 'with valid attributes' do
      it 'deletes his own answer in the database' do
        expect { delete :destroy, question_id: question, id: answer }.to change(Answer.where(question_id: question.id, user_id: @user.id), :count).by(-1)
      end
      it 'redirect to show view' do
        post :create, question_id: question, answer: answer.attributes
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with other user attributes' do
      let!(:other_user) { create(:user) }
      let!(:other_user_answer) { create(:answer, question_id: question.id, user_id: other_user.id) }
      it 'deletes his own answer in the database' do
        expect { delete :destroy, question_id: question, id: other_user_answer }.not_to change(Answer.where(question_id: question.id, user_id: other_user.id), :count)
      end
      it 'redirect to show view' do
        delete :destroy, question_id: question, id: other_user_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
