class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: %i[create destroy]
  def create # rubocop:disable Metrics/MethodLength
    @subscription = @community.subscriptions.new
    @subscription.community = @community

    respond_to do |format|
      if @subscription.save
        format.turbo_stream
        format.html { redirect_to community_path(@community), notice: 'You successfully subscribed.' }
      else
        format.html do
          redirect_to community_path(@community), alert: 'Something went ary subscribing to the community.'
        end

      end
    end
  end

  def destroy
    @subscription = @community.subscriptions.where(user_id: current_user).first.destroy
    respond_to do |format|
      format.html do
        redirect_back fallback_location: community_path(@community),
                      notice: 'No longer part of the X_NAME community :).'
      end
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
