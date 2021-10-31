#!/usr/bin/env bash
set -e -u -o pipefail

[[ ${DEBUG:-0} -eq 1 ]] && set -x
. /etc/service/date.sh --source-only

#service check
for s in openvpn dante nginx; do
  if [[ $(sv status ${s}) =~ ^run ]]; then
    continue
  else
    log " HEALTHCHECK: ERROR: ${s} process not running"
    exit 1
  fi
done

#Network check
res=$( (echo "state";sleep 1)| telnet ::1 7505)
if [[ ! ${res} =~ CONNECTED,SUCCESS, ]]; then
  log " HEALTHCHECK: ERROR, openvpn is not connected.${res}"
  exit 1
fi

log " HEALTHCHECK: INFO: Openvpn processes are running"
exit 0
