class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :find_communities

  def find_communities
    @communities = Community.all.order(:title)
  end

  def search
    # return unless params[:q].present?

    @results - PgSearch.multisearch(params[:q])
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username comment_subscription]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
