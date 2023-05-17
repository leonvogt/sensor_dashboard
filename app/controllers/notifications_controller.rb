class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications
                                 .order(created_at: :desc)
                                 .limit(10)
                                 .to_a
                                 .reject { |n| n.params[:noticed_error].present? }
  end
end
