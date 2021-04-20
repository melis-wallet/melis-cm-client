#!/bin/bash
set -ex

export FASTBOOT_DISABLED=true 
ember serve "$@"
