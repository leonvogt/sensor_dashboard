import Toastify from 'toastify-js'

// Documentation: https://github.com/apvarun/toastify-js/blob/master/README.md
export function toast(type, message) {
  const toastifyColors = {
    "success": "linear-gradient(to right, #1795BD, #1e40af)",
    "info": "linear-gradient(to right, #00b09b, #96c93d)",
    "error": "linear-gradient(to right, #ff416c, #ff4b2b)",
    "warning": "linear-gradient(to right, #f7b733, #fc4a1a)",
  }

  const options = {
    text: message,
    duration: 3000,
    close: true,
    gravity: "top",
    position: "right",
    stopOnFocus: true,
    style: {
      background: toastifyColors[type]
    }
  }

  Toastify(options).showToast();
}
