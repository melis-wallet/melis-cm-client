const buildVersionCode = function(version) {
      let [major, minor, patch] = version.toLowerCase().replace('-', '').split('.')
      return (major * 100000) + (minor * 1000) + (patch * 10);
  }

let version = process.argv[2];
if(version) {
  code = buildVersionCode(version).toString();
  process.stdout.write(code);
}
