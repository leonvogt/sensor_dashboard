module TurboStreamActionsHelper
  def toast(type, message)
    turbo_stream_action_tag :toast, data: { controller: 'toastify', toastify_type_value: type, toastify_message_value: message }
  end
end
Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
