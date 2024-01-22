# frozen_string_literal: true

module Admin
  # Returns all submissions, sorted in ascending order.
  class SubmissionsController < ApplicationController
    def index
      @submissions = Submissions.all.sort
    end
  end
end
