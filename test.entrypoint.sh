#! /bin/bash

set -e

TEST_URL="${TEST_URL:-http://localhost/}"
OIDC_URL="${OIDC_URL}"
USERNAME="${USERNAME:-${USER:-test}}"
PASSWORD="${PASSWORD}"
ROLES="birth,death,marriage,partnership,full-details"
CLIENT_ID="${CLIENT_ID:-dredd}"
CLIENT_SECRET="${CLIENT_SECRET}"
WAIT="${WAIT}"

DEBUG="${DEBUG}"

dredd="./bin/dredd ./swagger.yaml ${TEST_URL}"
token="DUMMY"

function esc {
    echo "${1//&/\\&}"
}

probe_api="curl -fs '${TEST_URL}/readiness' &> /dev/null"

if [ -n "${WAIT}" ]; then
    echo "Waiting until server is ready..."
    set +e
    eval "${probe_api}";
    while [ $? -ne 0 ]; do
        echo ...;
        sleep 5;
        eval "${probe_api}";
    done;
    set -e
    echo "Done."
fi

if [ -n  "${OIDC_URL}" ]; then
  echo "Requesting access token from ${OIDC_URL} for user, '${USERNAME}', as client, '${CLIENT_ID}'..."
  payload=$(curl -fs "${OIDC_URL}/token" -X POST \
              -H "Accept: */*" \
              -d "client_id=`esc ${CLIENT_ID}`&client_secret=`esc ${CLIENT_SECRET}`&username=`esc ${USERNAME}`&password=`esc ${PASSWORD}`&grant_type=password")
  [ -n "${DEBUG}" ] && echo "Received payload: ${payload}"
  token=`echo "${payload}" | jq -rM ".access_token"`
  [ -n "${DEBUG}" ] && echo "Parsed out token: ${token}"
  echo "Starting tests with OAuth2 bearer token..."
  ${dredd} -h "Authorization: Bearer ${token}"
else
  echo "Starting tests..."
  ${dredd} -h "X-Auth-Username: ${USERNAME}" -h "X-Auth-Aud: ${CLIENT_ID}" -h "X-Auth-Roles: ${ROLES}"
fi
