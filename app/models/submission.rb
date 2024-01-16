class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :media
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, length: { maximum: 8000, minimum: 10 }

  acts_as_votable

  def total_vote_count
    (get_upvotes.size - get_downvotes.size).to_s
  end
end
