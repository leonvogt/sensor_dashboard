import { Controller } from "@hotwired/stimulus"
// This controller is used to add a form template to the page
// Main reason why this is needed, is for dynamically creating new "nested_attributes forms"

// Connects to data-controller="form-template"
export default class extends Controller {
  static targets = ["template", "templateOutput"]

  addTemplate() {
    const template = this.templateTarget.cloneNode(true).innerHTML.replace(/idx/g, Date.now());
    this.templateOutputTarget.insertAdjacentHTML("beforeend", template);
  }
}
