import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
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


// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static values = { autoCloseTimeout: Number }
//   static targets = ["modal"];

//   connect() {
//     document.addEventListener("keydown", this.closeWithKeyboard.bind(this));
//         if (this.autoCloseTimeoutValue) {
//       setTimeout(() => {
//         this.element.close()
//       }, this.autoCloseTimeoutValue)
//     }
//   }

//   disconnect() {
//     document.removeEventListener("keydown", this.closeWithKeyboard.bind(this));
//   }

//   close() {
//     const modalFrame = document.getElementById("modal");
//     if (modalFrame) {
//       modalFrame.innerHTML = ""; // Очистка контенту модалки
//     }
//   }

//   closeWithKeyboard(event) {
//     if (event.key === "Escape") {
//       this.close();
//     }
//   }

//   closeBackground(event) {
//     if (event.target === this.element) {
//       this.close();
//     }
//   }
// }