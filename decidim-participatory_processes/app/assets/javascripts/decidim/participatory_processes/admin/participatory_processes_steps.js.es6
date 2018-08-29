(() => {
  const $singleDate = $("#participatory_process_step_single_date");
  const $endDate = $("#date_field_participatory_process_step_end_date").parent();
  $singleDate.on("click", () => {
    $endDate.toggleClass("hidden");
  });
})(window);
