class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_one_attached :media

  validates :title, presence: true
  validates :body, length: { maximum: 8000, minimum: 10 }
end
