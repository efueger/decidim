// = require colorpicker.min

$(() => {
  ColorPicker(

    document.getElementById('color-picker'),

    function(hex, hsv, rgb) {
      console.log(hsv.h, hsv.s, hsv.v);         // [0-359], [0-1], [0-1]
      console.log(rgb.r, rgb.g, rgb.b);         // [0-255], [0-255], [0-255]
      document.body.style.backgroundColor = hex;        // #HEX
    });
});
