module API::Internal::V1::Android
  class PathConfigurationsController < API::Internal::V1::AuthsController
    skip_before_action :authenticate_token!
    # https://github.com/hotwired/turbo-ios/blob/main/Docs/PathConfiguration.md
    # Icons by: https://github.com/google/material-design-icons/tree/master/android
    # When adding a new icon, the `NavigationTabData.kt` file in the Android app must be updated as well.

    def show
      render json: {
        settings: {
          screenshots_enabled: true,
          register_with_account: false,
          require_authentication: true,
          tabs: [
            {
              title: I18n.t("dashboard.title"),
              path: dashboard_path,
              icon: "home"
            },
            {
              title: Device.model_name.human(count: 2),
              path: devices_path,
              icon: "settings_remote"
            },
            {
              title: Notification.model_name.human(count: 2),
              path: notifications_path,
              icon: "notifications",
              show_notification_badge: true
            }
          ].to_json
        },
        rules: [
          {
            patterns: [".*"],
            properties: {
              context: "default",
              uri: "turbo://fragment/web",
              fallback_uri: "turbo://fragment/web",
              pull_to_refresh_enabled: true
            }
          },
          {
            patterns: [
              "^$",
              "^/$",
              "/dashboard$"
            ],
            properties: {
              uri: "turbo://fragment/web/home",
              presentation: "replace_root"
            }
          },
          {
            patterns: ["/refresh_historical_location"],
            properties: {
              uri: "turbo://fragment/web/home",
              presentation: "refresh"
            }
          },
          {
            patterns: ["/recede_historical_location"],
            properties: {
              uri: "turbo://fragment/web/home",
              presentation: "pop"
            }
          },
          {
            patterns: ["/new$", "/edit$"],
            properties: {
              context: "modal",
              uri: "turbo://fragment/web/modal/sheet",
              pull_to_refresh_enabled: false
            }
          },
          {
            patterns: ["/users/sign_in"],
            properties: {
              uri: "turbo://fragment/users/sign_in",
              context: "modal"
            }
          },
          {
            patterns: ["/users/sign_up"],
            properties: {
              uri: "turbo://fragment/users/sign_up",
              context: "modal"
            }
          },
          {
            patterns: ["/account/password/edit"],
            properties: {
              uri: "turbo://fragment/account/password/edit",
              context: "modal"
            }
          }
        ]
      }
    end
  end
end
