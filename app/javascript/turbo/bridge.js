// This Bridge class is consumed by the Turbo Native App.
// Some documentation on Turbo Native JS Bridge can be found here:
// https://github.com/hotwired/turbo-android/blob/main/docs/ADVANCED-OPTIONS.md#native---javascript-integration
// https://masilotti.com/turbo-ios/the-javascript-bridge (Shout out to Joe Masilotti for this helpful article! 🙌)

export default class Bridge {

  // This function can be called by the Turbo Native App to save the current mobile app settings.
  static registerMobileApp(mobileAppSettings) {
    fetch("/mobile_app_connections", {
      body: JSON.stringify({
        notification_token: mobileAppSettings["pushNotificationToken"],
        unique_mobile_id: mobileAppSettings["uniqueMobileId"],
        platform: mobileAppSettings["platform"],
        app_version: mobileAppSettings["appVersion"]
      }),
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
    });
  }

  static getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
