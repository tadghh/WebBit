class Submission < ApplicationRecord
  extend FriendlyId
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

  friendly_id :slug_candidates, use: %i[slugged finders]

  def slug_candidates
    [:title, %i[title id]]
  end

  def should_generate_new_friendly_id?
    if !slug?
      title_changed?
    else
      false
    end
  end

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
