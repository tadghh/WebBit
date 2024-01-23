# frozen_string_literal: true

# Mailer, for premium subscriptions
class PremiumSubscriptionMailer < ApplicationMailer
  def payment_failed
    @user = params[:user]

    mail to: @user.email, subject: 'Premium payment failed! :('
  end
end
