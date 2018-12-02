#!/bin/sh

set -e -u -o pipefail

cf push --no-start --vars-file .cf-vars.yml

app_guid=$(cf app drone --guid)
DRONE_DATABASE_DATASOURCE=$(cf curl "/v2/apps/$app_guid/env" | jq -r '.system_env_json.VCAP_SERVICES.postgres[].credentials.uri')

cf set-env drone DRONE_DATABASE_DATASOURCE "$DRONE_DATABASE_DATASOURCE"

cf start drone
