/* eslint-disable no-undef */
$(() => {
  const lang = document.getElementsByTagName("html")[0].getAttribute("lang");

  const timeagoInstance = timeago();
  const nodes = document.querySelectorAll(".time-ago");
  timeagoInstance.render(nodes, lang);
});
