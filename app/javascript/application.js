import "@hotwired/turbo-rails"
import TurboPower from 'turbo_power'
import { StreamActions } from "@hotwired/turbo"
import "./controllers"
import { log } from "webpack/lib/node/nodeConsole"

TurboPower.initialize(StreamActions)

StreamActions.open_modal = function() {
  const modal_id = this.getAttribute("modal_id")
  const modal = document.querySelector('book-form-modal')
  modal.classList.remove("hidden")
  modal.showModal()
}


StreamActions.close_modal = function() {
  document.querySelectorAll("dialog.modal").forEach(modal => {
    const controller = modal.controller
    if (controller) {
      controller.close()
    } else {
      modal.close()
      modal.classList.add("hidden")
    }
  })
}
