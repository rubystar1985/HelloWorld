class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable
  has_many :votes, as: :voteable

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  scope :is_best, -> { where(is_best: true) }
  scope :best_first, -> { order('is_best desc, created_at asc') }

  def set_best
    Answer.transaction do
      Answer.update_all(is_best: false, question_id: question.id)
      self.update!(is_best: true)
    end
  end

  def balanced_count
    positive_votes = votes.where(positive: true)
    negative_votes = votes.where(positive: false)

    @votes_count = positive_votes.count - negative_votes.count
  end

  def voted_by_current_user
    votes.where(user_id: user_id).count > 0
  end
end
