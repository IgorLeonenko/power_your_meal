import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "checkbox"]

  submit() {
    this.element.requestSubmit();
  }

  reset() {
    this.inputTargets.forEach(input => input.value = '');
    this.checkboxTargets.forEach(checkbox => checkbox.checked = false);
    this.submit();
  }
}
