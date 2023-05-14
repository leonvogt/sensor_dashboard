import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = ["navBar"]

  connect() {
    window.addEventListener("toggle-nav-bar", this.toggle.bind(this))
  }

  toggle() {
    this.navBarTarget.classList.toggle("mobile-menu--active");
  }
}
