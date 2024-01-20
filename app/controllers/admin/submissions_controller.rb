class Admin::SubmissionsController < ApplicationController
  def index
    @submissions = Submissions.all.sort
  end
end
