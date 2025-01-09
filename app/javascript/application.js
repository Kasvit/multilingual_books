import "@hotwired/turbo-rails"
import TurboPower from 'turbo_power'
import { StreamActions } from "@hotwired/turbo"
import "./controllers"

TurboPower.initialize(StreamActions)

StreamActions.open_modal = function() {
  const modal_id = this.getAttribute("modal_id")
  const modal = document.querySelector(modal_id)
  modal.classList.remove("hidden")
  modal.showModal()
}

StreamActions.upsert_modal = function() {
  const modal_id = this.getAttribute("modal_id")
  const modal_html = this.getAttribute("html")
  const modal = document.querySelector(modal_id)
  console.log('upset modal from application.js', modal_id, modal)
  if(modal) {
    modal.remove()
  }

  document.body.insertAdjacentHTML("beforeend", modal_html);
}

StreamActions.close_modal = function() {
  document.querySelectorAll("modal").forEach(modal => {
    modal.close()
  })
}
