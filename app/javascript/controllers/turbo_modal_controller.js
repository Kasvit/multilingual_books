import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"];

  connect() {
    document.addEventListener("keydown", this.closeWithKeyboard.bind(this));
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeWithKeyboard.bind(this));
  }

  close() {
    const modalFrame = document.getElementById("modal");
    if (modalFrame) {
      modalFrame.innerHTML = ""; // Очистка контенту модалки
    }
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape") {
      this.close();
    }
  }

  closeBackground(event) {
    if (event.target === this.element) {
      this.close();
    }
  }
}