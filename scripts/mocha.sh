#! /bin/bash

set -ex

#trap "exit" INT

nyc mocha --no-cache \
  -c \
  --require mocha.config.js \
  --timeout 30000 \
  --reporter mocha-multi-reporters \
  --reporter-options configFile=package.json \
   $@
