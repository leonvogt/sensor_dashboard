import { Controller } from "@hotwired/stimulus"
// Dieser Controller kann für Elemente verwendet werden, die standardmässig
// nicht klickbar sind, wie z.B. <tr>

// Mittels `data-action="mousedown->clickable-element#click_start mouseup->clickable-element#maybe_open_link"`
// kann zudem bestimmt werden, dass ein Link erst geöffnet wird, wenn eine maximale Zeit gedrückt wurde.
// damit kann unterschieden werden ob es ein klick war oder ein drag

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
