import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  detect() {
    navigator.geolocation.getCurrentPosition(({ coords }) => {
      this.fieldTarget.value = `${coords.latitude.toFixed(4)}, ${coords.longitude.toFixed(4)}`
    })
  }

  fill() {}
}
