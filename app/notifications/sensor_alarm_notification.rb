# Firebase Cloud Messaging is integrated using the `noticed` gem.
# Documentation: https://github.com/excid3/noticed

class SensorAlarmNotification < Noticed::Base
  # Add required params
  # param :post

  deliver_by :fcm, credentials: :fcm_credentials, format: :format_notification

  def fcm_device_tokens(user)
    user.mobile_app_connections.pluck(:notification_token)
  end

  # Follow this guide to get your credentials: https://github.com/excid3/noticed/blob/master/docs/delivery_methods/fcm.md#google-firebase-cloud-messaging-notification-service
  def fcm_credentials
    credentials =  File.read(Rails.root.join("config/credentials/firebase.json"))
    JSON.parse(credentials)
  end

  def format_notification(device_token)
    {
      token: device_token,
      notification: {
        title: "Test Title",
        body: "Test body"
      }
    }
  end

  # Firebase Cloud Messaging Notifications may fail delivery if the user has removed the app from their device.
  def cleanup_device_token(token:, platform:)
    MobileAppConnection.where(notification_token: token).destroy_all
  end
end
