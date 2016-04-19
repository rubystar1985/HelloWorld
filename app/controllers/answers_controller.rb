class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:new, :create, :destroy]
  before_action :load_answer, only: :destroy

  def create
    @question = Question.find(params[:question_id])
    @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    if user_signed_in? && current_user.author_of?(@answer)
      @answer.destroy
      flash_message = 'Your answer successfully deleted.'
    else
      flash_message = 'You can delete only your own answer.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
