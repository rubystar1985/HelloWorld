class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:new, :create, :destroy]
  before_action :load_answer, only: :destroy

  def create
    @answer = @question.answers.new answer_params
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully saved.'
    else
	    render :new
    end
  end

  def destroy
    if user_signed_in? and current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @question, notice: 'You can delete only your own answer.'
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
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
