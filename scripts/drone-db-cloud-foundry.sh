#!/bin/sh

set -e -u -o pipefail

cf create-service postgres tiny-unencrypted-9.5 drone-db
