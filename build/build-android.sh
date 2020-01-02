#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
#corber=./node_modules/corber/bin/corber
corber=corber

if [ "$#" -le 2 ]; then
   echo "Usage: build <target> <version> <keystorepassword>"
   exit -1
fi

target=$1
version=$2
pass=$3
key=$4

$DIR/cordova-prepare.sh android $target $version

if [ -z "$APKDIR" ]; then
  APKDIR=/tmp/a
fi

if [ ! -z "$pass" ]; then
  JARSIGNER_OPTS="-storepass $pass"
fi

# temporary fix for mismatcing versions in cordova build
#cp $DIR/cordova/patch/build-extras.gradle $CDV/platforms/android

DIR=$CDV/platforms/android/app/build/outputs/apk/
DEPLOY_TARGET="$target" $corber build --environment=production --platform=android --release
if [[ $? != 0 ]]; then
  echo "*** BUILD ERRORS"
else
  if [[ "$key" == "upload" ]]; then
    jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-upload-key.keystore $DIR/release/app-release-unsigned.apk melis-upload-key
  else
    jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-android.keystore $DIR/release/app-release-unsigned.apk melis_android
  fi
  zipalign -f -v 4 $DIR/release/app-release-unsigned.apk $APKDIR/melis-$target.apk
  echo "*** BUILD FINISHED"
fi
