'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');


module.exports = function(defaults) {

  let app = new EmberApp(defaults, {
    /*
    "ember-cli-babel": {
      includePolyfill: true,
    }, */

    'ember-bootstrap': {
      whitelist: ['bs-collapse', 'bs-popover', 'bs-tooltip'],
      'bootstrapVersion': 3,
      'importBootstrapCSS': false,
      'importBootstrapFont': true
    },

    SRI: {
      enabled: true
    },

    sassOptions: {implementation: require("node-sass")},

    'ember-cli-image-transformer': {
      images: [
        {
          inputFilename: 'public/images/melis-badger-r.svg',
          outputFileName: 'appicon-',
          convertTo: 'png',
          destination: 'assets/icons/',
          sizes: [32, 128, 192, 280, 512]
        }
      ]
    },

    'asset-cache': {
      include: [
        'assets/**/*',
        'images/**/*',
        'coins/**/*',
        'fonts/**/*'
      ]
    },

    'esw-cache-fallback': {
      patterns: [ '/' ],
      version: '1' // Changing the version will bust the cache
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
        { reserved:
          ['Array', 'BigInteger', 'Boolean', 'ECPair', 'Function', 'Number', 'Point', 'Script']
        }
      }

    },

    minifyCSS: {
      options: {
        processImport: false
      }
    },

    fingerprint: {
      extensions: ['js', 'css', 'png', 'jpg', 'gif', 'map'],
      exclude: ['donate-']
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

