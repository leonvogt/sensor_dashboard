import { StreamActions } from "@hotwired/turbo"
import { toast } from "../global/toast"

StreamActions.notify = function() {
  const type = this.getAttribute("type")
  const message = this.getAttribute("message")

  showFlashMessage(type, message)
}

StreamActions.reload_with_notify = function() {
  const url = isTurboNativeApp() ? "/refresh_historical_location" : window.location.href
  const type = this.getAttribute("type")
  const message = this.getAttribute("message")

  Turbo.visit(url)
  showFlashMessage(type, message)
}

function showFlashMessage(type, message) {
  if (isTurboNativeApp()) {
    window.bridge.postMessage("showFlashMessage", { message: message, type: type })
  } else {
    toast(type, message)
  }
}

function isTurboNativeApp() {
  return navigator.userAgent.indexOf("Turbo Native") !== -1
}
