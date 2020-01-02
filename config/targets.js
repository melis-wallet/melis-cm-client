let browsers;

if (process.env.CORBER) {
  browsers = [`last 1 ${process.env.CORBER_PLATFORM} versions`];
} else {
  // out-of-the-box ember-cli behaviour
  browsers = [
    'last 1 Chrome versions',
    'last 1 Firefox versions',
    'last 1 Safari versions'
  ];

  const isCI = !!process.env.CI;
  const isProduction = process.env.EMBER_ENV === 'production';

}

module.exports = {
  browsers
};
