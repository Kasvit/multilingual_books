import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.element.classList.add("animate-slide-in-right");
    setTimeout(() => this.hide(), 2000);
  }

  hide() {
    this.element.classList.remove("animate-slide-in-right");
    this.element.classList.add("animate-slide-out-right");
    this.element.addEventListener("animationend", () => this.remove(), { once: true });
  }

  close() {
    this.hide();
  }

  remove() {
    this.element.remove();
  }
}
