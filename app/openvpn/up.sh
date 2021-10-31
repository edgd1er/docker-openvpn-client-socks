#!/usr/bin/env bash

. /etc/service/date.sh --source-only

#exec expected openvpn up script
/etc/openvpn/up.sh $*

#Wait 10 seconds for openvpn to finish resolv.conf modification
sleep 5
log "########################################################"
log "INFO: openvpn: up script: params: $*"

[[ ${DEBUG:-0} -eq 1 ]] && set -x && cat /etc/resolv.conf

for s in dante nginx
  do
    log "INFO: OPENVPN: up: start ${s}"
    sv start ${s}
done

