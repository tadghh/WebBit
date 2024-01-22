class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    event = nil
    begin
      event = Stripe::Webhook.contruct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { message: e }, status: 400
      nil
    rescue Stripe::SignatureVerificationError => e
      render json: { message: e }, status: 400
      nil
    end
    case event.type
    when 'checkout.session.completed'
      return unless User.exists?(event.data.object.client_reference_id)

      fullfill_order(event.data.object)
    when 'invoice.payment.succeeded'
      return unless event.data.object.subscription.present?

      stripe_subscription = Stripe::Subscription.retrieve(event.data.object.subscription)
      premium_subscription = Subscription.find_by(subscriptions_id: stripe_subscription)

      premium_subscription.update(
        current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
        current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
        plan: stripe_subscription.plan.id,
        interval: stripe_subscription.plan.interval,
        status: stripe_subscription.status
      )
    when 'invoice.payment_failed'
      user = User.find_by(stripe_id: event.data.object.customer)
      if user.exists?
        PremiumSubscriptionMailer.with(user:)
        payment_failed.deliver_now
      end
    when 'customer.subscription.update'
      stripe_subscription = event.data.object
      if stripe_subscription.cancel_at_period_end == true
        premium_subscription = Subscription.find_by(subscription_id: stripe_subscription)

        if premium_subscription.present?
          premium_subscription.update(
            current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
            current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
            plan: stripe_subscription.plan.id,
            interval: stripe_subscription.plan.interval,
            status: stripe_subscription.status
          )
        end
      end
    else
      puts "Unhandled stripe event type: #{event.type}"
    end
  end

  private

  def fullfill_order(checkout_session) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    # find user and assign customer id
    user = User.find(checkout_session.client_reference_id)
    user.update(stripe_id: checkout_session.customer)
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)
    PremiumSubscription.create(
      customer_id: stripe_subscription.customer,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval,
      status: stripe_subscription.status,
      subscription_id: stripe_subscription.id,
      user:
    )
  end
end
