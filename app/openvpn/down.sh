#!/usr/bin/env bash

. /etc/service/date.sh --source-only

#exec expected openvpn up script
/etc/openvpn/down.sh $*


[[ ${DEBUG:-0} -eq 1 ]] && set -x
for s in dante nginx; do
  log "INFO: OPENVPN: down: stop ${s}"
  sv stop ${s}
done
