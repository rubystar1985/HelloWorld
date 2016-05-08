class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  scope :is_best, -> { where(is_best: true) }
  scope :best_first, -> { order('is_best desc, created_at asc') }

  def set_best
    Answer.transaction do
      Answer.update_all(is_best: false, question_id: question.id)
      self.update!(is_best: true)
    end
  end
end
