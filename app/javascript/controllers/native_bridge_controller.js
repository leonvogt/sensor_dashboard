import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="native-bridge"
export default class extends Controller {
  static values = { message: String }

  postMessage() {
    window.bridge.postMessage(this.messageValue)
  }
}
