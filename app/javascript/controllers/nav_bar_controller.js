import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

// Connects to data-controller="nav-bar"
export default class extends Controller {
  static targets = ["navBar", "navContent"]

  connect() {
    useClickOutside(this, { element: this.navContentTarget })

    // Listen for toggle-nav-bar event (gets called from the TurboNative Bridge)
    window.addEventListener("toggle-nav-bar", this.toggle.bind(this))
  }

  toggle() {
    this.navBarTarget.classList.toggle("mobile-menu--active")
  }

  // Close NavBar when clicking outside of it
  clickOutside() {
    if (this.navBarTarget.classList.contains("mobile-menu--active")) {
      this.toggle()
    }
  }
}
