$(document).ready(function() {
  var smoothie = new SmoothieChart();
  smoothie.streamTo(document.getElementById("mycanvas"), 1000);

  var ws = new WebSocket("ws://127.0.0.1:8080", "johnny-protocol");

  // Data
  var line1 = new TimeSeries();

  ws.onmessage = function(message) {
    line1.append(new Date().getTime(), message.data);
  };

  // setInterval(function() {
  //   ws.send("johnny:test-" + new Date().getTime());
  // }, 1000);

  // Add to SmoothieChart
  smoothie.addTimeSeries(line1);
});