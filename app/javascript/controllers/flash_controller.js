import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Automatically hide the flash message after 5 seconds
    setTimeout(() => {
      this.dismiss()
    }, 2000)
  }

  dismiss() {
    this.element.classList.add("opacity-0")
    setTimeout(() => {
      this.element.remove()
    }, 500) // Wait for fade out animation to complete
  }
}
