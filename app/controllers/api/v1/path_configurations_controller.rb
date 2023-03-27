class Api::V1::PathConfigurationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    render json: {
      settings: {
        screenshots_enabled: true
      },
      rules: [
        {
          patterns: [
            ".*"
          ],
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
            "^/$"
          ],
          properties: {
            uri: "turbo://fragment/web/home",
            presentation: "replace_root"
          }
        },
        {
          patterns: [
            "/new$",
            "/edit$"
          ],
          properties: {
            context: "modal",
            uri: "turbo://fragment/web/modal/sheet",
            pull_to_refresh_enabled: false
          }
        }
      ]
    }
  end
end
