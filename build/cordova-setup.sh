#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
corber=./node_modules/corber/bin/corber

platform=$1
if [ -z "$1" ]; then
  echo "Usage: config <platform> <target>"
  exit -1
fi

target=$2
case "$target" in
  production)
    echo "-- production build"
    appname='Melis Wallet'
    cid='io.melis.clientwallet'
    ;;
  testnet)
    echo "-- testnet build"
    appname='Melis (Testnet)'
    cid='io.melis.testwallet'
    ;;
  regtest)
    echo "-- regtest build"
    appname='Melis (Regtest)'
    cid='io.melis.regtestwallet'
    ;;
  *)
    echo "-- unknown target '$2'"
    exit -1
    ;;
esac


#ember generate ember-cordova --name=$appname --cordovaid=cid
$corber init --name=$appname --cordovaid=$cid

cp $CDV/config.xml $CDV/config.xml-
cp $DIR/cordova/config-$target.xml $CDV/config.xml

mkdir $CDV/res
cp $APP/public/images/melis-badger-r.svg $CDV/res/melis.svg
cp $APP/public/images/melis-splash.svg $CDV/res/melis-splash.svg


$corber make-icons --source $CDV/res/melis.svg --platform $platform
$corber make-splashes --source $CDV/res/melis-splash.svg --platform $platform

$corber platform add $platform
$corber prepare
$corber plugin add phonegap-plugin-barcodescanner
$corber plugin add ionic-plugin-keyboard
$corber plugin add cordova-plugin-network-information
$corber plugin add cordova-plugin-statusbar
$corber plugin add cordova-plugin-splashscreen
$corber plugin add https://github.com/hypery2k/cordova-email-plugin.git

if [ "$platform" == "android" ]; then
  $corber plugin add cordova-plugin-android-fingerprint-auth
fi

patch -p0 < $DIR/cordova/patch/studio.patch
