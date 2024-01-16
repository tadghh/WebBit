class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[edit update destroy show]
  before_action :set_submission

  def new; end

  def create
    @comment = @submission.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      format.turbo_stream
      if @comment.save
        format.html { redirect_to submission_path(@submission), notice: 'Comment posted successfully' }
      else
        format.html { redirect_to submission_path(@submission), alert: 'Comment could not be created' }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      format.turbo_stream
      if @comment.update(comment_params)
        format.html { redirect_to submission_path(@submission), notice: 'Comment posted successfully' }
      else
        format.html { redirect_to submission_path(@submission), alert: 'Comment could not be created' }
      end
    end
  end

  def upvote; end
  def downvote; end

  def destroy
    @comment.destroy
    # respond_to do |format|
    #   format.turbo_stream {turbo_stream.remove @comment}
    #   format.html {redirect_to submission_path(@submission), notice: "Comment deleted"}
    redirect_to submissions_path(@submission)
  end

  private

  def set_submission
    @submission = Submission.find(params[:submission_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:reply, :submission_id)
  end
end
