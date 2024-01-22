# frozen_string_literal: true

# Handles behaviours relating to a submission
class SubmissionsController < ApplicationController # rubocop:disable Metrics/ClassLength
  include ActionView::RecordIdentifier

  before_action :set_submission, only: %i[show edit update destroy upvote downvote]
  # I feel like unsubscribe could be handled better
  before_action :authenticate_user!, except: %i[index show unsubscribe]

  # GET /submissions or /submissions.json
  def index
    @submissions = if user_signed_in?
                     @feed_title = 'My feed'
                     current_user.subscribed_submissions
                   else
                     @feed_title = 'Select a community'
                     Submission.all
                   end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    @community = @submission.community
    @subscription = @community.subscriptions.where(user: current_user).first
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit; end

  # Below has not been tested, this fix was covered in lesson 28 - concerns and bugfixes.
  def upvote # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if current_user.voted_for? @submission
        format.html do
          redirect_back fallback_location: root_path,
                        alert: 'Voted already'
        end
      else
        @submission.upvote_by current_user
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "#{dom_id(@submission)}_votes_count",
            @submission.total_vote_count
          )
        end
      end
    end
  end

  def downvote # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if current_user.voted_for? @submission
        format.html do
          redirect_back fallback_location: root_path,
                        alert: 'U mad?'
        end
      else
        @submission.downvote_by current_user
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "#{dom_id(@submission)}_votes_count",
            @submission.total_vote_count
          )
        end
      end
    end
  end

  def unsubscribe
    User.find_by_unsubscribe_hash(unsubscribe_hash: params[:unsubscribe_hash])
    update(comment_subscription: false)
  end

  # POST /submissions or /submissions.json
  def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @submission = Submission.new(submission_params)
    @submission.user_id = current_user.id

    respond_to do |format|
      if @submission.save
        format.html do
          redirect_to submission_url(@submission),
                      notice: 'Submission was successfully created.'
        end
        format.json do
          render :show,
                 status: :created,
                 location: @submission
        end
      else
        format.html do
          render :new,
                 status: :unprocessable_entity
        end
        format.json do
          render json: @submission.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @submission.update(submission_params)
        format.html do
          redirect_to submission_url(@submission),
                      notice: 'Submission was successfully updated.'
        end
        format.json do
          ender :show,
                status: :ok,
                location: @submission
        end
      else
        format.html do
          render :edit,
                 status: :unprocessable_entity
        end
        format.json do
          render json: @submission.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy!

    respond_to do |format|
      format.html do
        redirect_to submissions_url,
                    notice: 'Submission was successfully destroyed.'
      end
      format.json do
        head :no_content
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def submission_params
    params.require(:submission).permit(:title, :body, :url, :media, :community_id)
  end
end
