# frozen_string_literal: true

# Represent a community, communities are centered around one topic and have submissions related to that topic
class Community < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model
  multisearchable against: %i[title name]

  belongs_to :user
  has_many :submissions

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates_associated :submissions

  friendly_id :slug_candidates, use: %i[slugged finders]

  def slug_candidates
    [:title, %i[title name]]
  end

  def should_generate_new_friendly_id?
    if !slug?
      title_changed?
    else
      false
    end
  end
end
