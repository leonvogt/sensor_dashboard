module Turbo
  class DeviseFailureApp < Devise::FailureApp
    include Turbo::Native::Navigation

    def respond
      if turbo_native_app?
        #  Turbo Native app expects a 401 response, when the user is not authenticated
        # that way it know it needs to show the native login screen
        http_auth
      else
        super
      end
    end
  end
end
