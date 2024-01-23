# frozen_string_literal: true

# Users subscribe to communities, this keeps track of that so we can personalize a users feed
class Subscription < ApplicationRecord
  belongs_to :community
  belongs_to :user
end
