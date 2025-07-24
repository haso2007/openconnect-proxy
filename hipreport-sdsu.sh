#!/bin/bash
# 动态获取系统信息
CURRENT_IP=$(curl -s ifconfig.io/ip)
HOSTNAME=$(hostname)
# 生成随机但合理的 host-id (UUID格式)
HOST_ID=$(cat /proc/sys/kernel/random/uuid)

cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<hip-report>
    <md5-sum>$(echo -n "$(date +%s)$HOSTNAME" | md5sum | cut -d' ' -f1)</md5-sum>
    <user-name>YOUR_SDSU_USERNAME</user-name>
    <domain></domain>
    <host-name>$HOSTNAME</host-name>
    <host-id>$HOST_ID</host-id>
    <ip-address>$CURRENT_IP</ip-address>
    <ipv6-address></ipv6-address>
    <categories>
        <entry name="host-info">
            <client-version>6.2.7-1047</client-version>
            <os>Microsoft Windows 10 Pro</os>
            <os-vendor>Microsoft</os-vendor>
            <arch>64-bit</arch>
        </entry>
        <entry name="antivirus">
            <list>
                <entry>
                    <ProductInfo>
                        <Prod name="Windows Defender" version="4.18.24090.5" vendor="Microsoft Corporation"/>
                        <real-time-protection>yes</real-time-protection>
                        <last-full-scan-time>n/a</last-full-scan-time>
                    </ProductInfo>
                </entry>
            </list>
        </entry>
        <entry name="anti-spyware">
            <list>
                <entry>
                    <ProductInfo>
                        <Prod name="Windows Defender" version="4.18.24090.5" vendor="Microsoft Corporation"/>
                        <real-time-protection>yes</real-time-protection>
                        <last-full-scan-time>n/a</last-full-scan-time>
                    </ProductInfo>
                </entry>
            </list>
        </entry>
        <entry name="firewall">
            <list>
                <entry>
                    <ProductInfo>
                        <Prod name="Windows Defender Firewall" version="10.0" vendor="Microsoft Corporation"/>
                        <is-enabled>yes</is-enabled>
                    </ProductInfo>
                </entry>
            </list>
        </entry>
        <entry name="patch-management">
            <list>
                <entry>
                    <ProductInfo>
                        <Prod name="Windows Update" version="10.0" vendor="Microsoft Corporation"/>
                        <is-enabled>yes</is-enabled>
                    </ProductInfo>
                </entry>
            </list>
        </entry>
    </categories>
</hip-report>
EOF

exit 0
