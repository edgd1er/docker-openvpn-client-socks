# https://www.cisco.com/c/en/us/support/docs/security/web-security-appliance/118076-configure-wsa-00.html
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_PAC_file


function FindProxyForURL(url,host)
{
    var host_ip = dnsResolve(host)

    var proxy_2 = array(
        );

        for (var i = 0, var count = proxy_2.length; i < length; i++) {
            if (
                localHostOrDomainIs(host, proxy_1[i])
            ) {
                return "SOCKS ${PAC_HOST}";
            }
        }
    //
    // Connect through a SOCKS server for everything on
    // `strange.server.com` under the `socks` subdirectory
    //
    if (
        shExpMatch(url, ${PAC_DOMAIN})
    ) {
        return "SOCKS ${PAC_HOST}";
    //
    //  And through a normal PROXY server for everything
    //  on `strange.server.com` under the `proxy` subdirectory
    //
    } elseif (
        shExpMatch(url, "strange.server.com/proxy/*")
    ) {
        return "PROXY ${PAC_HOST}";
    }
    //
    // Directly connect to everything else
    //
    return "DIRECT";
}
