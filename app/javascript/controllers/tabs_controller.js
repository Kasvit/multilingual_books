import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    if (this.tabTargets.length > 0) {
      const firstTab = this.tabTargets[0]
      const language = firstTab.dataset.language
      this.activateTab(language)
    }
  }

  showTranslation(event) {
    const language = event.currentTarget.dataset.language
    this.activateTab(language)
  }

  activateTab(language) {
    this.tabTargets.forEach(button => {
      if (button.dataset.language === language) {
        button.classList.add('active')
      } else {
        button.classList.remove('active')
      }
    })

    this.contentTargets.forEach(content => {
      if (content.dataset.language === language) {
        content.classList.remove('hidden')
      } else {
        content.classList.add('hidden')
      }
    })
  }
} 