# frozen_string_literal: true

# Represents a comment on a submission
# A submission will have a comment
# A user will create a comment
#
# Comments replies are indexed when searching
class Comment < ApplicationRecord
  include PgSearch::Model
  include VotesCountable

  multisearchable against: :reply

  belongs_to :submission
  belongs_to :user

  validates :reply, presence: true

  acts_as_votable
end
