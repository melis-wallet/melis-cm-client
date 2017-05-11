#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/ember-cordova/cordova

if [ "$#" -le 1 ]; then
   echo "Usage: build <target> <version>"
   exit -1
fi

target=$1
version=$2

$DIR/cordova-prepare.sh ios $target $version

DEPLOY_TARGET="$target" ember cordova:build --environment=production --platform=ios --release
if [[ $? != 0 ]]; then
  echo "*** BUILD ERRORS"
else
  echo "*** BUILD FINISHED"
fi
