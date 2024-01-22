# frozen_string_literal: true

# Finds the profile of user, including any content(Comments, subsmissions) they have created
class ProfilesController < ApplicationController
  def show
    @profile = User.find(params[:id])
    @submissions = @profile.submissions.order(created_at: :desc)
    @comments = @profile.comments.order(created_at: :asc)
  end
end
