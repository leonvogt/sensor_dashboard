import { Controller } from "@hotwired/stimulus"
import { showModal } from "../custom/tailwind_modal"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"]
  static values = { autoShow: Boolean }

  connect() {
    this.modal = this.hasModalTarget ? this.modalTarget : this.element;

    if (this.autoShowValue) {
      this.show();
    }
  }

  show() {
    showModal(this.modal);
  }
}
