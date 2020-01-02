/* eslint-env node */
'use strict';

module.exports = function(/* environment, appConfig */) {
  // See https://github.com/san650/ember-web-app#documentation for a list of
  // supported properties

  return {
    name: "Melis Wallet",
    short_name: "Melis Wallet",
    description: "A secure multisignature bitcoin wallet",
    start_url: "/",
    display: "standalone",
    background_color: "#333",
    theme_color: "#f49f1f",
    icons: [
      {
        src: "/assets/icons/appicon-32.png",
        sizes: "32x32",
        type: "image/png"
      },
      {
        src: "assets/icons/appicon-192.png",
        sizes: "192x192"
      },
      {
        src: "assets/icons/appicon-512.png",
        sizes: "512x512"
      }
    ]
  };
}
