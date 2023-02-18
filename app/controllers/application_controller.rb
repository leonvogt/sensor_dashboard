class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  def set_locale
    if current_user.present? && ['de', 'en'].include?(params[:locale])
      current_user.update_attribute(:locale, params[:locale])
    end
    I18n.locale = params[:locale] || current_user&.locale || I18n.default_locale
  end

  def authorize_resource(resource)
    render_forbidden if resource.user != current_user
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
