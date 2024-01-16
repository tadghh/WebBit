class Comment < ApplicationRecord
  belongs_to :submission
  belongs_to :user

  validates :reply, presence: true

  acts_as_votable

  def total_vote_count
    (get_upvotes.size - get_downvotes.size).to_s
  end
end
