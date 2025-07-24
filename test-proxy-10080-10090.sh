#!/bin/bash

# 代理测试脚本 - 端口 10080/10090

echo "=== 代理连接测试 (端口 10080/10090) ==="
echo "测试HTTP和SOCKS5代理连通性"
echo

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取服务器IP（如果在本地测试使用127.0.0.1）
SERVER_IP=${1:-"127.0.0.1"}

# 如果第一个参数是"watch"，则使用默认IP
if [ "$1" = "watch" ]; then
    SERVER_IP="127.0.0.1"
fi

echo "测试服务器: $SERVER_IP"
echo

# 测试HTTP代理函数
test_http_proxy() {
    local proxy="$1"
    local url="$2"
    
    echo -n "测试 HTTP代理 $proxy -> $url ... "
    
    result=$(curl -x "$proxy" -s -m 10 "$url" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 成功${NC}"
        
        # 解析IP信息 - 修复JSON解析
        ip=$(echo "$result" | grep -o '"ip": *"[^"]*"' | sed 's/"ip": *"\([^"]*\)"/\1/')
        country=$(echo "$result" | grep -o '"country": *"[^"]*"' | sed 's/"country": *"\([^"]*\)"/\1/')
        org=$(echo "$result" | grep -o '"org": *"[^"]*"' | sed 's/"org": *"\([^"]*\)"/\1/')
        
        echo "    IP: $ip"
        echo "    国家: $country"
        echo "    组织: $org"
        echo
    else
        echo -e "${RED}❌ 失败${NC}"
        echo
    fi
}

# 测试SOCKS5代理函数
test_socks5_proxy() {
    local proxy="$1"
    local url="$2"
    
    echo -n "测试 SOCKS5代理 $proxy -> $url ... "
    
    result=$(curl -x "socks5://$proxy" -s -m 10 "$url" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 成功${NC}"
        
        # 解析IP信息 - 修复JSON解析
        ip=$(echo "$result" | grep -o '"ip": *"[^"]*"' | sed 's/"ip": *"\([^"]*\)"/\1/')
        country=$(echo "$result" | grep -o '"country": *"[^"]*"' | sed 's/"country": *"\([^"]*\)"/\1/')
        org=$(echo "$result" | grep -o '"org": *"[^"]*"' | sed 's/"org": *"\([^"]*\)"/\1/')
        
        echo "    IP: $ip"
        echo "    国家: $country"
        echo "    组织: $org"
        echo
    else
        echo -e "${RED}❌ 失败${NC}"
        echo
    fi
}

# 执行测试
echo "=== HTTP代理测试 (端口 10080) ==="
test_http_proxy "$SERVER_IP:10080" "https://ipinfo.io/json"

echo "=== SOCKS5代理测试 (端口 10090) ==="
test_socks5_proxy "$SERVER_IP:10090" "https://ipinfo.io/json"

echo "=== 测试完成 ==="

# 使用示例
if [ "$1" = "watch" ]; then
    echo "持续监控模式..."
    while true; do
        echo "$(date): 测试代理连接..."
        curl -x "$SERVER_IP:10080" -s -m 5 "https://ipinfo.io/json" | jq -r '.ip' 2>/dev/null || echo "HTTP代理连接失败"
        curl -x "socks5://$SERVER_IP:10090" -s -m 5 "https://ipinfo.io/json" | jq -r '.ip' 2>/dev/null || echo "SOCKS5代理连接失败"
        sleep 5
    done
fi

echo
echo "使用方法:"
echo "  本地测试: ./test-proxy-10080-10090.sh"
echo "  远程测试: ./test-proxy-10080-10090.sh <服务器IP>"
echo "  监控模式: ./test-proxy-10080-10090.sh watch"



