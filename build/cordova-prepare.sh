#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
corber=corber

file=corber/cordova/config.xml

SETUP=$DIR/cordova-setup.sh

if [ "$#" -le 1 ]; then
   echo "Usage: prepare <ios|android> <target>"
   exit -1
fi

platform=$1
target=$2
version=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

versionCode=`node $DIR/versioncode.js $version`

echo "Version: '$version', versioncode: '$versionCode'"

yarn remove corber --save
yarn remove ember-cli-sri --save

rm -rf tmp corber
$SETUP $platform $target
sed -i -e 's:__ver__:'$version':g' $file
sed -i -e 's:__vc__:'$versionCode':g' $file


case "$platform" in
  ios)
    cp $DIR/cordova/GoogleService-Info-$target.plist $CDV/platforms/ios/GoogleService-Info.plist
    cp $DIR/cordova/GoogleService-Info-$target.plist $CDV/GoogleService-Info.plist
    cp $DIR/cordova/google-services-melis-$target.json $CDV/google-services.json
    ;;
  android)
    cp $DIR/cordova/google-services-melis-$target.json $CDV/platforms/android/app/google-services.json
    ;;

  *)
     echo "-- unknown platform '$platform'"
     exit -1
     ;;
esac


# we do not have a corresponding app profile for regtest fcm
if [ "$target" != "regtest" ]; then
  echo
  # using the fork at cmgustavo/cordova-plugin-fcm
  $corber plugin add cordova-plugin-fcm-ng
fi
