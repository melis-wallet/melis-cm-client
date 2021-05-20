#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
corber=corber

if [ "$#" -lt 1 ]; then
   echo "Usage: build <target> [<keystorepassword>] [<keystoretype>]"
   echo "Target can be either: [regtest|testnet|production]"
   exit -1
fi

target=$1
pass=$2
key=$3

$DIR/cordova-prepare.sh android $target $version

if [ -z "$APKDIR" ]; then
  APKDIR=$DIR/dist
fi

if [ ! -z "$pass" ]; then
  JARSIGNER_OPTS="-storepass $pass"
fi

DIR=$CDV/platforms/android/app/build/outputs/apk/
DEPLOY_TARGET="$target" $corber build --environment=production --platform=android --release
if [[ $? != 0 ]]; then
  echo "*** BUILD ERRORS"
else
  if [ -z "$pass" ]; then
    echo 'Artifact will not be signed'
    cp $DIR/release/app-release-unsigned.apk $APKDIR/melis-$target-unsigned.apk
  else
    echo 'Artifact will be signed'
    if [[ "$key" == "upload" ]]; then
      jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-upload-key.keystore $DIR/release/app-release-unsigned.apk melis-upload-key
    else
      jarsigner $JARSIGNER_OPTS -sigalg SHA1withRSA -digestalg SHA1 -keystore ../ChainMaster/etc/melis-android.keystore $DIR/release/app-release-unsigned.apk melis_android
    fi
    zipalign -f -v 4 $DIR/release/app-release-unsigned.apk $APKDIR/melis-$target.apk
  fi
  echo "*** BUILD FINISHED"
fi
