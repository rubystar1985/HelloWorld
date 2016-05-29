class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :votes, as: :voteable

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  def balanced_count
    positive_votes = votes.where(positive: true)
    negative_votes = votes.where(positive: false)

    @votes_count = positive_votes.count - negative_votes.count
  end

  def voted_by_current_user
    votes.where(user_id: user_id).count > 0
  end
end
