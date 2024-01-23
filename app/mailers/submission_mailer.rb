# frozen_string_literal: true

# Mailer
class SubmissionMailer < ApplicationMailer
  def new_response
    @comment = params[:comment]
    @submission = params[:submission]
    @greeting = 'Hi'

    mail to: @submission.user.email, subject: "New comment #{@submission.title}"
  end
end
