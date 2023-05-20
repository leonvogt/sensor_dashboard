// Turbo
import * as Turbo from "@hotwired/turbo"

import Bridge from "./turbo/bridge.js";
window.bridge = Bridge;
import './turbo/custom_stream_actions'

// Stimulus
import "./controllers"

// Everything else
import "./global/**/*"
import "./custom/**/*"
