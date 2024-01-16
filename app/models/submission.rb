class Submission < ApplicationRecord
  include VotesCountable
  belongs_to :user
  belongs_to :community
  has_one_attached :media
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, length: { maximum: 8000, minimum: 10 }

  acts_as_votable
end
