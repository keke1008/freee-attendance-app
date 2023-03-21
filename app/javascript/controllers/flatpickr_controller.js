import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Japanese } from "flatpickr/dist/l10n/ja";

export default class extends Controller {
  connect() {
    const config = {
      locale: Japanese,
      dateFormat: "Y/m/d H:i:S",
      enableTime: true,
      enableSeconds: true,
    };
    flatpickr(this.element, config);
  }
}
