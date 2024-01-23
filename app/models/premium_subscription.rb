# frozen_string_literal: true

# The relationship between a subscription and its user
class PremiumSubscription < ApplicationRecord
  belongs_to :user
end
