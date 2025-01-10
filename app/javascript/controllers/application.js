import { Application } from "@hotwired/stimulus"
import TC from "@rolemodel/turbo-confirm"

TC.start()

const application = Application.start()

application.debug = false
window.Stimulus   = application

export { application }
