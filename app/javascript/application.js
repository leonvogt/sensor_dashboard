import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false

import "@fortawesome/fontawesome-free/js/all"

// Initializers
import "./init/tailwind"

// Import Stimulus controllers
import "./controllers"

// Global JS functions
import './global/chart_functions'
