import { Controller } from "@hotwired/stimulus"
import Toastify from 'toastify-js'

// Documentation: https://github.com/apvarun/toastify-js/blob/master/README.md

// Connects to data-controller="toastify"
export default class extends Controller {
  static values = {
    type: String,
    message: String
  }

  connect() {
    this.toastifyColors = {
      "success": "linear-gradient(to right, #1795BD, #1e40af)",
      "info": "linear-gradient(to right, #00b09b, #96c93d)",
      "error": "linear-gradient(to right, #ff416c, #ff4b2b)",
      "warning": "linear-gradient(to right, #f7b733, #fc4a1a)",
    }

    this.options = {
      text: this.messageValue,
      duration: 3000,
      close: true,
      gravity: "top",
      position: "right",
      stopOnFocus: true,
      style: {
        background: this.toastifyColors[this.typeValue],
        minWidth: "250px",
      }
    }

    Toastify(this.options).showToast();
  }
}
