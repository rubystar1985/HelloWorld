require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let!(:answer) { create(:answer, question: question, user_id: user.id) }

  describe 'POST #create' do
    sign_in_user

    context 'vote for question with valid attributes' do
      it 'saves the new vote associated with question in the database' do
        expect { post :create, question_id: question, positive: true, format: :js }.to change{ question.votes.reload.size }.by(1)
      end

      it 'render create template' do
      post :create, question_id: question, positive: true, format: :js
        expect(response).to render_template :create
      end
    end

    context 'vote for answer with valid attributes' do
      it 'saves the new vote associated with question in the database' do
        expect { post :create, question_id: question, answer_id: answer, positive: true, format: :js }.to change{ answer.votes.reload.size }.by(1)
      end

      it 'render create template' do
      post :create, question_id: question, answer_id: answer, positive: true, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
