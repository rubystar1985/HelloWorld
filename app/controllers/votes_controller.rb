class VotesController < ApplicationController
  def create
    @vote = Vote.new voteable_id: params[:question_id], voteable_type: 'Question', positive: params[:positive], user_id: current_user.id
    @vote.save
    @voteable = @vote.voteable
  end
end
