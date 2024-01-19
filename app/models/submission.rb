class Submission < ApplicationRecord
  include VotesCountable
  include PgSearch::Model

  multisearchable against: %i[title body url]

  belongs_to :user
  belongs_to :community
  has_one_attached :media
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, length: { maximum: 8000, minimum: 10 }
  validates :url, url: { allow_blank: true }
  validate :body_or_url
  validate :content_exists

  acts_as_votable

  private

  def body_or_url
    return if url.blank? || body.blank?
    return if url.blank? ^ body.blank?

    errors.add(:base, 'Add a valid URL or text content')
  end

  def content_exists
    return unless url.blank? && body.blank? && !media.attached?

    errors.add(:base, 'Add media to continue')
  end
end
