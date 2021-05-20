# melis-cm-client

This is the main repository for the [Melis Wallet](http://melis.io).

The wallet can be built as a:

* A **static, single-page web application**, that can be deployed on any web server capable of serving static assets, or **run locally with an integrated server**
* A Cordova based application for Android/iOS
* An Electron based desktop application for Windows, MacOS and Linux

The three platforms share the same code, with only an handful of native plugins to handle specific hardware requirements (camera and barcode scanner, fingerprint unlock, etc...)


The wallet is written using [Ember](http://emberjs.com/). The following packages are also part of the wallet:

* [melis-cm-svcs](https://github.com/melis-wallet/melis-cm-svcs) which implements most of the wallet internal state ('headless' wallet) to which this repository is the frontend/UI.
* [melis-api-js](https://github.com/melis-wallet/melis-api-js) a library that provides a JavaScript API to access the remote Melis STOMP APIs.


#### Assets

This project depends on a a separate project `ember-leaf-theme-basic`, containing all the assets, css, graphics, fonts and visual components to build the final wallet. The `ember-leaf-theme-basic` package only contains these visual elements, and no active code except for a skeleton ember plugin that is needed for properly assembling the assets in the final project.


**Please note that, while the Melis Wallet itself is completely free and open source under the MIT License, the accompanying assets are not.**

You are welcome to use the assets to build your own personal copy for the Melis Wallet. You can also use the wallet's source under the term of the MIT License, but in that case you'll have to provide your own assets.
For these reasons the assets package is *not published in npm, so you will need to download it separately*.

Please refer to [The Assets License](ASSETS-LICENSE.md)




#### Note
The Melis project is in the process of rewriting the Melis Wallet using modern, more current, *Ember Octane* and Typescript. The new releases are going to be based on the upcoming rewrite, and this repository will only be maintained for bugfixes. This project is provided for transparency and to provide our users with the ability to run a verifiable build of the wallet on their own hardware.


## Prerequisites

The build is entirely based on `ember-cli`, so it should be fairly portable, but the process has only been tested on Linux and MacOS ì. Windows might work, but is unsupported.

You will need:

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (version 14+)
* [Yarn](http://yarnpkg.com/) (a current version)
* [Bower](http://bower.io/) 
* [Ember CLI](http://www.ember-cli.com/) (3.25+)

## Installation

Install all the global dependencies, if you do not have them already. You'll need something like:

* `npm install -g yarn bower ember-cli`


To be able to build a working application you will need to download and unpack the `ember-leaf-theme-basic` package from [https://github.com/melis-wallet/melis-cm-client/releases](https://github.com/melis-wallet/melis-cm-client/releases). 

Please note that the content of this page is subject to a separate license (see [The Assets License](ASSETS-LICENSE.md)), and **can not be redistributed** totally or in part. 

* download `ember-leaf-theme-basic-<version>` (the latest), from [https://github.com/melis-wallet/melis-cm-client/releases](https://github.com/melis-wallet/melis-cm-client/releases) and unzip it and rename as `ember-leaf-theme-basic` in the same folder as this `melis-cm-client`

* enter the `melis-cm-client` folder

* `yarn; bower install`

## Running / Development

* `ember serve`
* Visit your app at [http://localhost:4200](http://localhost:4200).

This way the application will run and connect to the `regtest` environment. 

**This is meant for development/troubleshooting, all coins will be fictional.**.


## Running a *production* wallet locally

To run your own wallet, locally, after having performed the *installation* steps

* `./wallet`
* Visit your wallet at [http://localhost:4200](http://localhost:4200).

**DO NOT** use the integrated webserver on the public internet. It is only meant to be used locally.


## Building a static web application 

`melis-cm-client` can be assembled into a static web application, that can be served through any webserver:

* `DEPLOY_TARGET='production' ember build --environment production `

The static application will be in `dist/`


`DEPLOY_TARGET=[production|testnet|regtest]` controls the backend the wallet will connect to. 

`--environment [production|development]` controls the level of optimization (logging, minification, etc...) for the resulting build.


## Android Application

At this point, we can only directly support building the *web version* of this client. 
While everything is provided to build the Android/iOS application, we can not provide step-by-step instructions for setting up your Android Studio, android SDK or Xcode environment.
The following steps are provided only as a reference for building the Cordova Android application.

**You're on your own here**. We understand this part is not user-friendly, we're working on it.


### Setting your environment

* **Perform the `installation` steps above and make sure the web application builds and runs successfully**
* install **Corber** and Cordova
* You need to set `JAVA_HOME` and `ANDROID_HOME` environment variables, and have a working environment for building Android and *Cordova* appliications. 

#### Dependencies:
* [Corber](http://corber.io/)
* [Apache Cordova](https://cordova.apache.org/)

###  Building a production application

* `build/build-android.sh <target>`

Target is one of `production`, `testnet`, `regtest`.

Artifacts will be in `buìld/dist/` unless you set `APKDIR`

### Building for development
( don't do this if you only intend to build the apk )

Setup the cordova build environment:

* `build/cordova-setup.sh`

Build an android app for live reload:

* `ember cdv:serve --platform=[android|ios] --reload-url=<url>`

Building a standalone app

* `DEPLOY_TARGET='<target>' ember cordova:build --environment=production --platform=[android|ios]`


### Notes
#### Analytics
* The application doesn't send analytics, and doesn't use any unique identifiers, but for those necessary to log in (ie: your wallet credentials), and a per device unique-id that changes each time you pair or enroll that device)
* it **will** send a stack trace, and error details, in case of an exception. You can opt-out from error reporting in the wallet preferences.
* `ember-cli`, which is used for building the application, by default, sends anonymous analytics to its authors (not us!) when you build the project (**not** when you run it in production). You can opt out by editing `.ember-cli` 
