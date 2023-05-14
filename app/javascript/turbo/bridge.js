// This Bridge class is consumed by the Turbo Native App.
// Some documentation on Turbo Native JS Bridge can be found here:
// https://github.com/hotwired/turbo-android/blob/main/docs/ADVANCED-OPTIONS.md#native---javascript-integration
// https://masilotti.com/turbo-ios/the-javascript-bridge (Shout out to Joe Masilotti for this helpful article! 🙌)

export default class Bridge {
  // Toggles navbar visibility in browser from Turbo Native
  static toggleNavBar() {
    const event = new CustomEvent("toggle-nav-bar")
    window.dispatchEvent(event)
  }

  // Sends a message to the native app, if active.
  static postMessage(name, data = {}) {
    window.nativeApp?.postMessage(JSON.stringify({name, ...data}))
  }
}
