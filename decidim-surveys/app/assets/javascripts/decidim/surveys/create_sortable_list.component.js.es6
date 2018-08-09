/* eslint-disable no-undef */
// = require ./Sortable.js

((exports) => {
  class CreateSortableList {
    constructor(options = {}) {
      this.class = options.class;
      this._run();
    }

    _run() {
      const sortables = document.getElementsByClassName(this.class);

      let refreshIndex = () => {
        for (let sortable of sortables) {

          $(sortable).find("input[type=checkbox]").prop("checked", false);
          $(sortable).find("input[type=checkbox]").prop("checked", true);

          let elements = $(sortable).children("label");

          for (let element of elements) {
            const idx = $(elements).index(element);
            const $positionSelector = $(element).children(".position");
            const $positionField = $(element).children("input[name$=\\[position\\]]");
            $positionField.val(idx);
            $positionField.prop("disabled", false);
            $positionSelector.html(`${idx + 1}.&nbsp`);

          }
        }
      };

      for (let sortable of sortables) {
        Sortable.create(sortable, {
          onUpdate: refreshIndex
        }
        );
        $(sortable).find("input[type=checkbox]").addClass("hidden");
        $(sortable).find(".position").html("&nbsp;&nbsp;");
        $(sortable).find("input[type=checkbox]").prop("checked", false);
      }
    }
  }

  exports.Decidim = exports.Decidim || {};
  exports.Decidim.createSortableList = (options) => {
    return new CreateSortableList(options);
  };
})(window);
