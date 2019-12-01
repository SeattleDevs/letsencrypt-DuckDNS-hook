#!/usr/bin/env bash

#
# dns-01 challenge for DuckDNS
# https://www.duckdns.org/spec.jsp

set -e
set -u
set -o pipefail

if [[ -z "${DUCKDNS_TOKEN}" ]]; then
  echo " - Unable to locate DuckDNS Token in the environment!  Make sure DUCKDNS_TOKEN environment variable is set"
fi

deploy_challenge() {
  local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
  echo -n " - Setting TXT record with DuckDNS ${TOKEN_VALUE}"
  curl -X PUT https://www.duckdns.org/update?domains=${DOMAIN}&token=${DUCKDNS_TOKEN}&txt=${TOKEN_VALUE}
  echo
  echo " - Waiting 30 seconds for DNS to propagate."
  sleep 30
}

clean_challenge() {
  local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
  echo -n " - Removing TXT record from DuckDNS ${DOMAIN}"
  curl -X PUT https://www.duckdns.org/update?domains=${DOMAIN}&token=${DUCKDNS_TOKEN}&txt=removed&clear=true
  echo
}

deploy_cert() {
  cp "${KEYFILE}" "${FULLCHAINFILE}" /etc/nginx/ssl/; chown -R nginx: /etc/nginx/ssl
  systemctl reload nginx
}

unchanged_cert() {
  local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}"
  echo "The $DOMAIN certificate is still valid and therefore wasn't reissued."
}

HANDLER="$1"; shift
if [[ "${HANDLER}" =~ ^(deploy_challenge|clean_challenge|deploy_cert|unchanged_cert)$ ]]; then
  "$HANDLER" "$@"
fi
