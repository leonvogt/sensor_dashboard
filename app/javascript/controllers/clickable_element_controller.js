import { Controller } from "@hotwired/stimulus"
// This controller can be used for elements that are not clickable by default, like <tr>

// By using `data-action="mousedown->clickable-element#click_start mouseup->clickable-element#maybe_open_link"`
// you can also specify that a link is only opened after a certain time has passed.
// This way you can distinguish between a click and a drag

// Connects to data-controller="clickable-element"
export default class extends Controller {
  open_link(event) {
    var url = this.element.dataset.url;
    var target = (event.ctrlKey || event.metaKey) ? '_blank' : '_self';
    window.open(url, target);
  }

  click_start(event) {
    this.startX = event.clientX;
    this.startY = event.clientY;
    this.startTime = new Date();
  }
  maybe_open_link(event) {
    // if clicked Element contains "no-link" class -> do nothing
    if (event.target.classList.contains("no-link")) {
      return;
    }

    //const secondsPressed = (new Date() - this.startTime) / 1000;
    const xDiff = Math.abs(event.clientX - this.startX);
    const yDiff = Math.abs(event.clientY - this.startY);

    if (xDiff < 5 && yDiff < 5) {
      this.open_link(event);
    }
  }
}
