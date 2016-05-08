require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index	}

    it 'populates an array of all question' do
      expect(assigns(:questions)).to match_array(@questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change{ @user.questions.reload.size }.by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-redirect new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render create template' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'valid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to include 'MyString'
        expect(question.body).to include 'MyText'
      end

      it 're-redirect edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:question) { create(:question, user_id: @user.id) }

    before { question }

    context 'deletes his own question' do
      it 'deletes question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context "deletes other user's question" do
      let!(:other_user) { create(:user) }
      let!(:other_user_question) { create(:question, user_id: other_user.id) }

      it 'deletes question' do
        expect { delete :destroy, id: other_user_question }.not_to change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, id: other_user_question
        expect(response).to redirect_to other_user_question
      end
    end
  end
end
