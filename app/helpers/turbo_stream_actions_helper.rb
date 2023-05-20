module TurboStreamActionsHelper
  def notify(type, message)
    turbo_stream_action_tag :notify, type: type, message: message
  end
  end
end
Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
