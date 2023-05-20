class ApplicationController < ActionController::Base
  include EsbuildErrorRendering if Rails.env.development?
  before_action :authenticate_user!
  before_action :set_locale
  before_action :set_variant
  before_action :check_user_privileges

  helper_method :breadcrumbs

  def breadcrumbs
    BreadcrumbsAssembler.new(controller_path, action_name, params).crumbs
  end

  def check_user_privileges
    if current_user&.guest? && action_name.in?(%w[create update destroy])
      # Guest users are not allowed to create, update or destroy resources
      # Only exceptions are the login and logout action
      return if controller_path == 'devise/sessions' && action_name.in?(%w[create destroy])
      render_forbidden
    end
  end

  def set_variant
    request.variant = :turbo if turbo_native_app?
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
        recede_or_redirect_back_or_to(root_path)
      end
      format.turbo_stream do
        flash[:error] = t('resource_not_allowed') if !turbo_native_app?

        # If we use a normal reload or redirect combined with the flash message,
        # the flash message can be shown twice on the Turbo Native App.
        # Therefore we use this custom turbo_stream action.
        render turbo_stream: turbo_stream.reload_with_notify('error', t('resource_not_allowed'))
      end
      format.json do
        render json: { status: 'error', message: t('resource_not_allowed') }, status: :forbidden
      end
    end
  end
end
