// Initializers
import { StreamActions } from "@hotwired/turbo"

// Turbo Native bridge
import Bridge from "./turbo/bridge.js";
window.bridge = Bridge;

// Custom StreamActions
StreamActions.toast = () => void 0;


// Import Stimulus controllers
import "./controllers"

// Global JS functions
import './global/chart_functions'

// Import custom JS
import './custom/tailwind_alerts'
import './custom/tailwind_tabs'
import './custom/tailwind_dropdowns'
