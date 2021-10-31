# OpenVPN-client

forked from [kizzx2/docker-openvpn-client-socks](https://github.com/kizzx2/docker-openvpn-client-socks)

* Differences from fork
    * run as service (openvpn, dante, nginx) using runit (start/stop scripts)
    * added nginx to serve a Proxy autoconfiguration file
    * healthcheck based on services status and openvpn connection status.
    
the main idea is to redirect selected hosts or domain(s) through a vpn to access private websites without redirecting all trafic through vpn.

first element of PAC_DOMAINS is assumed being the main domain to be redirected, wpad.domain1.tld will be served by nginx.

At the moment, foxy proxy (firefox extension) does the proxy redirection.

WIP and not tested: pac file.
Ideas for later: add also an http proxy.

----------------------------------------------------
Original README.md

This is a docker image of an OpenVPN client tied to a SOCKS proxy server.  It is
useful to isolate network changes (so the host is not affected by the modified
routing).

This supports directory style (where the certificates are not bundled together in one `.ovpn` file) and those that contains `update-resolv-conf`

(For the same thing in WireGuard, see [kizzx2/docker-wireguard-socks-proxy](https://github.com/kizzx2/docker-wireguard-socks-proxy))


## Why?

This is arguably the easiest way to achieve "app based" routing. For example, you may only want certain applications to go through your WireGuard tunnel while the rest of your system should go through the default gateway. You can also achieve "domain name based" routing by using a [PAC file](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file) that most browsers support.

## Usage

```docker
version: "3.5"
services:
  home:
    image: edgd1er/openvpn-client-socks-http-pac
    hostname: homevpn
    restart: unless-stopped
    ports:
      - '1081:80' # expose pac file
      - '1080:1080' #Exposes socks proxy
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - ./:/config/openvpn/
    environment:
      - TZ=Europe/Paris
      - PAC_DOMAINS="domain1.lan host.domain2.lan"
      - PAC_HOST=<host running container>:<exposed sockd proxy port>
      - DEBUG=0
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0 
```

Then connect to SOCKS proxy through through `localhost:1080` / `local.docker:1080`. For example:

```bash
curl --proxy socks5h://local.docker:1080 ipinfo.io
```

## HTTP Proxy

You can easily convert this to an HTTP proxy using [http-proxy-to-socks](https://github.com/oyyd/http-proxy-to-socks), e.g.

hpts -s 127.0.0.1:1080 -p 8080
