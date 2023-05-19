import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="native-bridge"
export default class extends Controller {
  static values = {
    title: String,
    body: Object,
    autoSend: Boolean
  }

  connect() {
    if (this.autoSendValue) {
      this.postMessage()
    }
  }

  postMessage() {
    window.bridge.postMessage(this.titleValue, this.bodyValue)
  }
}
