#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP=$(cd "${DIR}/.." && pwd)
CDV=$APP/corber/cordova
corber=./node_modules/corber/bin/corber

if [ "$#" -le 1 ]; then
   echo "Usage: build <target> <version>"
   exit -1
fi

target=$1
version=$2

$DIR/cordova-prepare.sh ios $target $version

DEPLOY_TARGET="$target" $corber build --environment=production --platform=ios --release
if [[ $? != 0 ]]; then
  echo "*** BUILD ERRORS"
else
  echo "*** BUILD FINISHED"
fi
