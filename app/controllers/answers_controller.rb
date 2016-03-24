class AnswersController < ApplicationController
	def new
		@question = Question.find params[:question_id]
		@answer = Answer.new(question_id: params[:question_id])
	end

	def create
		@answer = Answer.create(answer_params)
		if @answer.save
		  @question = Question.find params[:question_id]
		  redirect_to question_url(answer_params[:question_id])
		else
			render :new
		end
	end

	private

	def load_answer
		@answer = Answer.find params[:id]
	end

	def answer_params
		params.require(:answer).permit(:question_id, :body)
	end
end
