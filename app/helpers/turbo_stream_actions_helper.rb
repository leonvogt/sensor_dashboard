module TurboStreamActionsHelper
  def notify(type, message)
    turbo_stream_action_tag :notify, type: type, message: message
  end

  def reload_with_notify(type, message)
    turbo_stream_action_tag :reload_with_notify, type: type, message: message
  end
end
Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
