// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import FlashController from "./flash_controller"

eagerLoadControllersFrom("controllers", application)
application.register("flash", FlashController)
