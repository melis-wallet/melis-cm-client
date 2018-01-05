#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
corber=./node_modules/corber/bin/corber

file=corber/cordova/config.xml

SETUP=$DIR/cordova-setup.sh

if [ "$#" -le 2 ]; then
   echo "Usage: prepare <ios|android> <target> <version>"
   exit -1
fi

platform=$1
target=$2
version=$3


rm -rf tmp corber
$SETUP $platform $target
sed -i -e 's:version=".*" xmlns=:version="'$version'" xmlns=:g' $file

case "$platform" in
  ios)
    cp $DIR/cordova/GoogleService-Info-$target.plist $CDV/platforms/ios/GoogleService-Info.plist
    cp $DIR/cordova/GoogleService-Info-$target.plist $CDV/GoogleService-Info.plist
    cp $DIR/cordova/google-services-melis-$target.json $CDV/google-services.json
    ;;
  android)
    cp $DIR/cordova/google-services-melis-$target.json $CDV/google-services.json
    ;;

  *)
     echo "-- unknown platform '$platform'"
     exit -1
     ;;
esac


# we do not have a correspondig app profile for regtest fcm
if [ "$target" != "regtest" ]; then
  #ember cordova:plugin add cordova-plugin-fcm
  $corber plugin add https://github.com/lp1bp/cordova-plugin-fcm.git
  #patch -p0 < $DIR/cordova/patch/plugins-fcm.patch
fi
