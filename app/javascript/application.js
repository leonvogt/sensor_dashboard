// Initializers
import { StreamActions } from "@hotwired/turbo"
import "./init/fontawesome"

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
import './custom/mobile_menu'
