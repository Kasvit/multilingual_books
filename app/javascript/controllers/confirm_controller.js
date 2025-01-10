import { Controller } from "@hotwired/stimulus"

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
    this.element.close()
  }

  handleOutsideClick(event) {
    // Check if the dialog is currently open
    if (!this.element.open) return

    if (event.target.closest('.modal-overlay')) {
      this.element.close()
    }
  }
}
