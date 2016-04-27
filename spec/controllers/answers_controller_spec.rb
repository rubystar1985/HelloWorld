require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:answer) { build :answer, question_id: question }
      it 'saves the new answer associated with question in the database' do
        expect { post :create, question_id: question, answer: answer.attributes, format: :js }.to change{ question.answers.reload.size }.by(1)
      end

      it 'saves the new answer associated with question in the database' do
        expect { post :create, question_id: question, answer: answer.attributes, format: :js }.to change{ @user.answers.reload.size }.by(1)
      end

      it 'render create template' do
      post :create, question_id: question, answer: answer.attributes, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let (:answer) { build :invalid_answer, question_id: question.id }
        it 'does not save the answer' do
        expect { post :create, question_id: question, answer: answer.attributes, format: :js }.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, question_id: question, answer: answer.attributes, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) { create(:answer, question_id: question.id, user_id: @user.id) }

    context 'when author' do
      it 'deletes his own answer in the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change{ @user.answers.reload.size }.by(-1)
      end
      it 'render destroy template' do
        post :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not author' do
      let!(:other_user) { create(:user) }
      let!(:other_user_answer) { create(:answer, question_id: question.id, user_id: other_user.id) }
      it 'deletes his own answer in the database' do
        expect { delete :destroy, question_id: question, id: other_user_answer, format: :js }.not_to change(Answer, :count)
      end
      it 'render destroy template' do
        delete :destroy, question_id: question, id: other_user_answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user_id: user.id) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer.id, question_id: question.id, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question to @question' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template(:update)
    end
  end
end
