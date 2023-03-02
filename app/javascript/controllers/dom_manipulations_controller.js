import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dom-manipulations"
export default class extends Controller {
  static targets = ["element", "destroyField"]

  removeElement() {
    this.elementTargets.forEach(element => element.remove() )
  }

  hideElement() {
    this.elementTargets.forEach(element => element.classList.add("hidden") )
  }

  setDestroyField() {
    this.destroyFieldTargets.forEach(element => element.value = true )
  }
}
