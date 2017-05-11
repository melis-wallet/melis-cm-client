/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');


module.exports = function(defaults) {

  var app = new EmberApp(defaults, {
    /*
    "ember-cli-babel": {
      includePolyfill: true,
    }, */

    SRI: {
      enabled: true
    },

    minifyJS: {
      // test!
      //enabled: true,
      // lele - bitcoinjs-lib breaks if mangled
      // NOTE: When uglifying the javascript, you must exclude the following variable names from being mangled:
      // Array, BigInteger, Boolean, Buffer, ECPair, Function, Number, Point and Script.
      // This is because of the function-name-duck-typing used in typeforce.
      //options: {mangle: false }
      options: {mangle:
        { except:
          ['Array', 'BigInteger', 'Boolean', 'ECPair', 'Function', 'Number', 'Point', 'Script']
        }
      }

    },
    minifyCSS: {
      options: {
        processImport: false
      }
    }
  });


  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.


  // QR writer
  app.import(app.bowerDirectory + '/qrcode.js/qrcode.js');

  // Sparkline
  app.import(app.bowerDirectory + "/jquery.sparkline.build/dist/jquery.sparkline.js");


  // QR Decoder
  app.import('vendor/fixes.js')
  app.import(app.bowerDirectory + "/qrcode-decoder-js/lib/qrcode-decoder.js");

  // u2f host support
  app.import('vendor/u2f.js');

  // Smooth Scroll
  app.import(app.bowerDirectory + "/smooth-scroll/dist/js/smooth-scroll.js");


  // background positioning
  app.import('vendor/backstretch.js');

  // clipboard support
  app.import(app.bowerDirectory + "/clipboard/dist/clipboard.js");

  // notify.js
  app.import(app.bowerDirectory + "/notify.js/dist/notify.js");

  return app.toTree();
};

