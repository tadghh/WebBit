module SubmissionsHelper
  def inject_feed_ad(index)
    return unless ((index + 1) % 3).zero?

    render partial: 'feed_ad'
  end
end
