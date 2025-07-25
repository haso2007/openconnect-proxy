#!/bin/sh
# 等待VPN连接建立
sleep 15

if ip link show tun0 >/dev/null 2>&1; then
    echo "检测到VPN接口tun0，修复默认路由..."
    
    # 保留Docker网络路由（关键！）
    ip route add 172.17.0.0/16 via 172.17.0.1 dev eth0 2>/dev/null || true
    
    # 保留DNS路由
    ip route add 127.0.0.11/32 via 172.17.0.1 dev eth0 2>/dev/null || true
    ip route add 8.8.8.8/32 via 172.17.0.1 dev eth0 2>/dev/null || true
    ip route add 8.8.4.4/32 via 172.17.0.1 dev eth0 2>/dev/null || true
    
    # 删除默认路由
    ip route del default via 172.17.0.1 2>/dev/null || true
    
    # 添加VPN默认路由
    ip route add default dev tun0
    
    echo "路由修复完成"
    ip route
    
    # 测试DNS解析
    nslookup ipinfo.io || echo "DNS解析仍有问题"
else
    echo "未检测到VPN接口"
fi


