module API::Internal::V1
  class PathConfigurationsController < API::Internal::V1::AuthsController
    include ::PathConfigurationAssembler

    skip_before_action :authenticate_token!

    def show
      render json: path_configuration
    end
  end
end
