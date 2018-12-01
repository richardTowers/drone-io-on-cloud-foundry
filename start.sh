#!/bin/sh

set -e -u -o pipefail

cf push --no-start --vars-file .cf-vars.yml

DRONE_DATABASE_DATASOURCE=$(cf env drone | awk -F '"' '/postgres:/ { print $4 }')

cf set-env drone DRONE_DATABASE_DATASOURCE "$DRONE_DATABASE_DATASOURCE"

cf start drone
