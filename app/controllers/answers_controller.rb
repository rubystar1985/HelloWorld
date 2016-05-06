class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:new, :create, :update, :destroy, :set_best]
  before_action :load_answer, only: [:destroy, :update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
    @answer
  end

  def destroy
    if user_signed_in? && current_user.author_of?(@answer)
      @answer.destroy
      flash_message = 'Your answer successfully deleted.'
    else
      flash_message = 'You can delete only your own answer.'
    end
  end

  def set_best
    @answer = Answer.find(params[:answer_id])
    if current_user.author_of?(@answer.question)
      @answer.set_best
    else
      head 403
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
