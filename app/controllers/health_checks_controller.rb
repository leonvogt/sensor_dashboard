class HealthChecksController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    message = "success"

    begin
      User.count
    rescue
      message = "No DB connection"
    end

    render json: {message: message}, status: (message == "success") ? :ok : :internal_server_error
  end
end
