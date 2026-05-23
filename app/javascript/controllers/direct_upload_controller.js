import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  preview(event) {
    const previews = document.getElementById("photo-previews")
    previews.innerHTML = ""
    for (const file of event.target.files) {
      const img = document.createElement("img")
      img.src = URL.createObjectURL(file)
      img.className = "w-full aspect-square object-cover rounded"
      previews.appendChild(img)
    }
  }
}
