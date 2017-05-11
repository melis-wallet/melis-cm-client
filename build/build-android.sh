#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/ember-cordova/cordova

if [ "$#" -le 2 ]; then
   echo "Usage: build <target> <version> <keystorepassword>"
   exit -1
fi

target=$1
version=$2

$DIR/cordova-prepare.sh android $target $version

if [ -z "$APKDIR" ]; then
  APKDIR=/tmp/a
fi

pass=$3
if [ ! -z "$pass" ]; then
  JARSIGNER_OPTS="-storepass $pass"
fi

DIR=$CDV/platforms/android/build/outputs/apk/
DEPLOY_TARGET="$target" ember cordova:build --environment=production --platform=android --release
if [[ $? != 0 ]]; then
  echo "*** BUILD ERRORS"
else
  jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-android.keystore $DIR/android-armv7-release-unsigned.apk melis_android
  jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-android.keystore $DIR/android-x86-release-unsigned.apk melis_android
  zipalign -f -v 4 $DIR/android-x86-release-unsigned.apk $APKDIR/melis-x86-$target.apk
  zipalign -f -v 4 $DIR/android-armv7-release-unsigned.apk $APKDIR/melis-arm-$target.apk
  echo "*** BUILD FINISHED"
fi
