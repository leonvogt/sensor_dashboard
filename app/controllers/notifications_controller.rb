class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc).limit(10)
  end
end
