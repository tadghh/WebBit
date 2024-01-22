# frozen_string_literal: true

require 'active_support/concern'

# Used for keeping track of the votes on a post/submission/comment
module VotesCountable
  extend ActiveSupport::Concern
  included do
    def total_vote_count
      (get_upvotes.size - get_downvotes.size).to_s
    end
  end
end
