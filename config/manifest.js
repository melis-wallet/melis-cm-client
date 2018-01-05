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
    background_color: "#000",
    theme_color: "#f49f1f",
    icons: [
      {
        src: "/images/melis-icon.png",
        sizes: "32x32",
        type: "image/png"
      },
      {
        src: "/images/melis-badger-r.svg",
        sizes: "any"
      }
    ]
  };
}
