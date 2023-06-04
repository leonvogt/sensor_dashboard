module API::Internal::V1::IOS
  class PathConfigurationsController < API::Internal::V1::AuthsController
    skip_before_action :authenticate_token!
    # https://github.com/hotwired/turbo-ios/blob/main/Docs/PathConfiguration.md
    # Icons by: https://developer.apple.com/sf-symbols/
    # Icons can be updated without updating the iOS app.

    def show
      render json: {
        settings: {
          screenshots_enabled: true,
          register_with_account: false,
          tabs: [
            {
              title: I18n.t("dashboard.title"),
              path: dashboard_path,
              ios_system_image_name: "house"
            },
            {
              title: Device.model_name.human(count: 2),
              path: devices_path,
              ios_system_image_name: "sensor"
            },
            {
              title: Notification.model_name.human(count: 2),
              path: notifications_path,
              ios_system_image_name: "bell"
            }
          ]
        },
        rules: [
          {
            patterns: [
              "/new$",
              "/edit$",
              "/passwords/new"
            ],
            properties: {
              "presentation": "modal"
            }
          },
          {
            patterns: ["/users/sign_up"],
            properties: {
              flow: "registration"
            }
          },
          {
            patterns: ["/users/sign_in"],
            properties: {
              "flow": "authentication"
            }
          },
          {
            patterns: ["/account/password/edit"],
            properties: {
              "flow": "update_password"
            }
          }
        ]
      }
    end
  end
end
