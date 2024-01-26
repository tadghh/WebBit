# frozen_string_literal: true

# Handles subscriptions of a user to a community
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: %i[create destroy]

  def create # rubocop:disable Metrics/MethodLength
    @subscription = current_user.subscriptions.new
    @subscription.community = @community
    puts 'Subscription created gross\n\n\n\n\n\n\n/n/n/n/'
    respond_to do |format|
      if @subscription.save
        format.turbo_stream
        format.html do
          redirect_to community_path(@community),
                      notice: 'You have successfully subscribed.'
        end
      else
        format.html do
          redirect_to community_path(@community), alert: 'Something went ary subscribing to the community.'
        end
      end
    end
  end

  def destroy
    @subscription = @community.subscriptions.where(user: current_user).first
    @subscription.destroy
    puts 'Subscription destroyed gross\n\n\n\n\n\n\n/n/n/n/'

    respond_to do |format|
      format.html { redirect_to community_path(@comunity), notice: 'You successfully unsubscribed' }
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
