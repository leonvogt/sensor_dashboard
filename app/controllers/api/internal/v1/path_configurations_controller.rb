module API::Internal::V1
  class PathConfigurationsController < API::Internal::V1::AuthsController
    skip_before_action :authenticate_token!
    def show
      render json: {
        settings: {
          screenshots_enabled: true,
          tabs: [
            {
              title: "Dashboard",
              path: root_path,
              icon: "home"
            },
            {
              title: "Devices",
              path: devices_path,
              icon: "settings_remote"
            },
            {
              title: "Notifications",
              path: notifications_path,
              icon: "notifications"
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
            patterns: ["^$", "^/$"],
            properties: {
              uri: "turbo://fragment/web/home",
              presentation: "replace_root"
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
          }
        ]
      }
    end
  end
end
