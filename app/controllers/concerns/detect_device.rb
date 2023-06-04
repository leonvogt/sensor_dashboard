module DetectDevice
  extend ActiveSupport::Concern

  included do
    before_action :set_variant
  end

  def set_variant
    request.variant = :turbo if turbo_native_app?
  end

  # The `turbo-rails` gem already provides a `turbo_native_app?` method.
  # Here we check on which platform the Turbo Native App is running.
  def turbo_native_android_app?
    request.user_agent.to_s.match?(/Turbo Native Android/)
  end

  def turbo_native_ios_app?
    request.user_agent.to_s.match?(/Turbo Native iOS/)
  end
end
