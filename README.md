# Melis-cm-client

This README outlines the details of collaborating on this Ember application.
A short introduction of this app could easily go here.

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Installation

To be able to build a working application you will need to download and unpack the `ember-leaf-theme-basic` package from https://github.com/melis-wallet/melis-cm-client/releases. 

Please note that the content of this page is subject to a separate license (see `ASSETS-LICENSE.md`), and can not be redistributed totally or in part. 

* enter the melis-cm-client directory
* `yarn`
* `bower install`

## Running / Development

* `node i18n/generate-melis-i18n.js`
* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).


### Building

* `node i18n/generate-melis-i18n.js`
* `ember build` (development)
* `ember build --environment production` (production)
* `DEPLOY_TARGET='regtest' ember build --environment production (regtest)`

### Deploying

The built application can be deployed with any web server. Do not use `ember serve` as a production server.


## Electron App

### Checking out the 'electron' branch

* git checkout electron
* npm install

### Building

* DEPLOY_TARGET='<target>' ember electron:package  --platform=[linux|win32|darwin|all] --name '<app-name>'


## Android App

### Setting your environment

You need to set JAVA_HOME and ANDROID_SDK

### Preparing the build

build/cordova-setup.sh

### Building for develop

Build an android app for live reload

* ember cdv:serve --platform=[android|ios] --reload-url=<url>

###  Building a standalone app

* DEPLOY_TARGET='<target>' ember cordova:build --environment=production --platform=[android|ios]

###  Building a production app

Building for android assumes a Cordova environment has been set-up, and the Android SDK is correctly configured.
Also the `build-android.sh` script makes assumptions about the directory layout and the presence of a keystore.

* build/build-android.sh <target> <version-number> <signing-key-password>

or

* DEPLOY_TARGET='<target>' ember cordova:build --environment=production --platform=[android|ios] --release
* jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore <path-to-keystore> <path-to-apk> <key-id>
* zipalign -v 4 <input.apk> <output.apk>

## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)

