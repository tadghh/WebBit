class Community < ApplicationRecord
  include PgSearch::Model
  multisearchable against: %i[title name]

  belongs_to :user
  has_many :submissions

  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates_associated :submissions
end
