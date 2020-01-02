'use strict';

module.exports = function(environment) {
  let ENV = {
    modulePrefix: 'melis-cm-client',
    environment,
    rootURL: '',
    locationType: 'hash',
    exportApplicationGlobal: true,
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      },
      EXTEND_PROTOTYPES: {
        // Prevent Ember Data from overriding Date.parse.
        Date: false
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    'melis-session': {
      autologinTestPin:  null,
      appName: 'cm.melis',
      testMode: false
    },

    resizeServiceDefaults: {
      debounceTimeout    : 100,
      heightSensitive    : true,
      widthSensitive     : true
    },
    moment: {
      // To cherry-pick specific locale support into your application.
      // Full list of locales: https://github.com/moment/moment/tree/2.10.3/locale
      includeLocales: ['en', 'it'],
      outputFormat: 'LLL',
      allowEmpty: true
    },

    i18n: {
      defaultLocale: 'en'
    }
  };

  ENV.contentSecurityPolicy = {
     'default-src': "'none'",
     'script-src': "'self' 'unsafe-eval' 'unsafe-inline'",
     'font-src': "'self' data: https://fonts.gstatic.com", // Allow fonts to be loaded from http://fonts.gstatic.com
     'img-src': "'self' 'unsafe-inline' data:",
     'style-src': "'self' 'unsafe-inline' https://fonts.googleapis.com", // Allow inline styles and loaded CSS from http://fonts.googleapis.com
     'media-src': "'self'"
   };

  let session = ENV['melis-session'];
  let csp = ENV.contentSecurityPolicy;

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;

    session.testMode = true;
    session.autologinTestPin = '1234';
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV.APP.autoboot = false;
  }

  if (environment === 'production') {
  }

  var deployTarget = process.env.DEPLOY_TARGET;

  ENV.APP.recoveryUrls = ['https://recovery.melis.io/', 'https://github.com/melis-wallet/melis-recovery']

  if (deployTarget === 'local') {
    ENV.APP.publicUrl= 'https://wallet-regtest.melis.io';
    session.apiDiscoveryUrl =  'http://localhost:9090/api/v1/endpoint/stomp';
    csp['connect-src'] = "'self' ws://localhost:9090/stomp";
  }

  if (deployTarget === 'regtest') {
    ENV.APP.publicUrl= 'https://wallet-regtest.melis.io';
    session.apiDiscoveryUrl =  'https://discover-regtest.melis.io/api/v1/endpoint/stomp';
    csp['connect-src'] = "'self' wss://regtest-api.melis.io/stomp";
  }

  if (deployTarget === 'testnet') {
    ENV.APP.publicUrl= 'https://wallet-test.melis.io';
    session.apiDiscoveryUrl =  'https://discover-test.melis.io/api/v1/endpoint/stomp';
    csp['connect-src'] = "'self' wss://test-api.melis.io/stomp";
  }

  if (deployTarget === 'production') {
    ENV.APP.publicUrl= 'https://wallet.melis.io';
    session.apiDiscoveryUrl =  'https://discover.melis.io/api/v1/endpoint/stomp';
    ENV.APP.recoveryUrls = ['https://recovery.melis.io/', 'https://github.com/melis-wallet/melis-recovery']
    csp['connect-src'] = "'self' wss://api.melis.io/stomp";
  }

  return ENV;
};
