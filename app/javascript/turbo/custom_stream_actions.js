import { StreamActions } from "@hotwired/turbo"
import { toast } from "../global/toast"

StreamActions.notify = function() {
  const type = this.getAttribute("type")
  const message = this.getAttribute("message")

  if (isTurboNativeApp()) {
    window.bridge.postMessage("showFlashMessage", { message: message, type: type })
  } else {
    toast(type, message)
  }
}

function isTurboNativeApp() {
  return navigator.userAgent.indexOf("Turbo Native") !== -1
}
