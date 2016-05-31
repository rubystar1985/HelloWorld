class VotesController < ApplicationController
  def create
    if params[:answer_id].present?
      @vote = Vote.new voteable_id: params[:answer_id], voteable_type: 'Answer', positive: params[:positive], user_id: current_user.id
    else
      @vote = Vote.new voteable_id: params[:question_id], voteable_type: 'Question', positive: params[:positive], user_id: current_user.id
    end

    @voteable = @vote.voteable
    @vote.save
  end
end
