require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
  	before { get :new, question_id: question }
  	it 'assigns a new Answer to @answer' do
  		expect(assigns(:answer)).to be_a_new(Answer)
  	end

  	it 'renders new view' do
  		expect(response).to render_template :new
  	end
  end

	describe 'POST #create' do
    context 'with valid attributes' do
	    let (:answer) { build :answer, question_id: question }
		 	it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: answer.attributes }.to change{question.answers.count}.by(1)
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
end
