# Firebase Cloud Messaging is integrated using the `noticed` gem.
# Documentation: https://github.com/excid3/noticed
class SensorAlarmNotification < Noticed::Base
  param :rule_violation

  deliver_by :fcm, credentials: :fcm_credentials, format: :format_notification
  deliver_by :database

  # Follow this guide to get your credentials: https://github.com/excid3/noticed/blob/master/docs/delivery_methods/fcm.md#google-firebase-cloud-messaging-notification-service
  def fcm_credentials
    credentials = File.read(Rails.root.join("config/firebase.json"))
    JSON.parse(credentials)
  end

  def fcm_device_tokens(user)
    user.mobile_app_connections.pluck(:notification_token)
  end

  def title
    t('.title', device_name: params[:rule_violation].alarm_rule&.sensor&.device.to_s, locale: recipient.locale)
  end

  def body
    params[:rule_violation].violation_text
  end

  def format_notification(fcm_device_token)
    host = Rails.env.development? ? '192.168.1.10:3000' : Rails.application.config.action_mailer.default_url_options[:host]

    {
      token: fcm_device_token,
      notification: {
        title: title,
        body: body,
      },
      data: {
        sensor_id: params[:rule_violation].alarm_rule.sensor_id.to_s,
        url: devices_url(host: host)
      }
    }
  end

  # Firebase Cloud Messaging Notifications may fail delivery if the user has removed the app from their device.
  def cleanup_device_token(token:, platform:)
    MobileAppConnection.where(notification_token: token).destroy_all
  end
end
