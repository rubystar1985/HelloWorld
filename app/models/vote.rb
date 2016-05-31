class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true

  validate :no_vote_for_own

  private

    def no_vote_for_own
      if user_id == voteable.user_id
        errors.add(:author, "can't vote for/against your own")
      end
    end
end
