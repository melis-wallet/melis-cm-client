'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const nodeSass = require('node-sass'),
      environment = process.env.EMBER_ENV || 'development';


module.exports = function(defaults) {

  let app = new EmberApp(defaults, {
    /*
    "ember-cli-babel": {
      includePolyfill: true,
    }, */

    'ember-bootstrap': {
      'bootstrapVersion': 3,
      'importBootstrapCSS': false,
      'importBootstrapFont': false
    },

    SRI: {
      enabled: true
    },

    sassOptions: {
      implementation: nodeSass,
    },    

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

    'ember-service-worker': {
      versionStrategy: 'project-revision',
      enabled: (environment === 'production') ? true : false
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


    'ember-cli-terser': {
      //enabled: true,

      terser: { mangle:
        { reserved:
          ['Array', 'BigInteger', 'Boolean', 'ECPair', 'Function', 'Number', 'Point', 'Script', 'HDNode']
        },
        //keep_fnames: true,
        safari10: true,
      }
    },
    
    autoImport: {
      webpack: {  

        node: { 
          stream: true,
          crypto: true,
          fs: 'empty',
        },
        optimization: {
          minimize: false
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

