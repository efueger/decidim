(() => {
  const $singleDate = $("#participatory_process_step_single_date");
  const $endDate = $("#date_field_participatory_process_step_end_date");
  $singleDate.on("click", () => {
    if ($singleDate.val("checked")) {
      $endDate.addClass("hidden");
    }
    else {
      $endDate.removeClass("hidden");
    }
  });
})(window);
