class ApplicationController < ActionController::Base
  include EsbuildErrorRendering if Rails.env.development?
  before_action :authenticate_user!
  before_action :set_locale
  before_action :check_user_privileges

  def check_user_privileges
    if current_user&.guest? && action_name.in?(%w[create update destroy])
      # Guest users are not allowed to create, update or destroy resources
      # Only exceptions are the login and logout action
      return if controller_path == 'devise/sessions' && action_name.in?(%w[create destroy])
      render_forbidden
    end
  end

  def set_locale
    if current_user.present? && ['de', 'en'].include?(params[:locale])
      current_user.update_attribute(:locale, params[:locale])
    end
    I18n.locale = params[:locale] || current_user&.locale || I18n.default_locale
  end

  def authorize_resource(resource)
    render_forbidden if resource.user_id != current_user.id
  end

  def render_forbidden
    respond_to do |format|
      format.html do
        flash[:error] = t('resource_not_allowed')
        redirect_to root_path
      end
      format.json do
        render json: { status: 'error', message: t('resource_not_allowed') }, status: :forbidden
      end
    end
  end
end
