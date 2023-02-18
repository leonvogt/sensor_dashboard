class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  def set_locale
    if current_user.present? && ['de', 'en'].include?(params[:locale])
      current_user.update_attribute(:locale, params[:locale])
    end
    I18n.locale = params[:locale] || current_user&.locale || I18n.default_locale
  end
end
