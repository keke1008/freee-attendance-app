import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Japanese } from "flatpickr/dist/l10n/ja";

const FIELD_OPTIONS = {
  date: {
    enableTime: false,
    enableDate: true,
    format: "Y/m/d",
  },
  time: {
    enableTime: true,
    enableDate: false,
    format: "H:i:S",
  },
  datetime: {
    enableTime: true,
    enableDate: true,
    format: "Y/m/d H:i:S",
  },
};

export default class extends Controller {
  static values = {
    field: String,
  };

  connect() {
    const field = this.fieldValue || "date";
    if (!Object.keys(FIELD_OPTIONS).includes(field)) {
      throw new Error(`"${field}" is not a valid field.`);
    }

    const option = FIELD_OPTIONS[field];
    const config = {
      locale: Japanese,
      enableSeconds: true,
      noCalendar: !option.enableDate,
      enableTime: option.enableTime,
      dateFormat: option.format,
    };

    flatpickr(this.element, config);
  }
}
