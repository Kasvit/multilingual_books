import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirm-modal"
export default class extends Controller {
  static values = { autoCloseTimeout: Number }

  connect() {
    if (this.autoCloseTimeoutValue) {
      setTimeout(() => {
        this.element.close()
      }, this.autoCloseTimeoutValue)
    }
  }

  close(event) {
    console.log('close event from modal controller')
    this.element.close()
  }

  handleOutsideClick(event) {
    console.log('handleOutsideClick event from modal controller')
    // Check if the dialog is currently open
    if (!this.element.open) return

    if (event.target.closest('.modal-overlay')) {
      this.element.remove()
    }
  }
}