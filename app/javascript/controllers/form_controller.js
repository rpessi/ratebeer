import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "year", "active"];

  clear() {
    this.nameTarget.value = "";
    this.yearTarget.value = "";
    if (this.activeTarget.checked) {
      this.activeTarget.click();
    }
  }
}
