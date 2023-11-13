#!/bin/bash

# Function to install nslookup if not already installed
install_nslookup() {
    if command -v apt &> /dev/null; then
        apt update
        apt install -y dnsutils
    elif command -v yum &> /dev/null; then
        yum install -y bind-utils
    else
        echo "错误：无法确定包管理器。请手动安装 nslookup 后再运行此脚本。"
        exit 1
    fi
}

# Check if nslookup is installed
if ! command -v nslookup &> /dev/null; then
    echo "未安装 nslookup，正在尝试安装..."
    install_nslookup
fi

# Run nslookup for netflix.com
result=$(nslookup netflix.com | awk '/^Address: / { print $2; exit }')

# Check if the result is empty
if [[ -z "$result" ]]; then
    echo "未能获取 netflix.com 的 IP 地址。"
    exit 1
fi

# Run curl for ipinfo.io
curl_result=$(curl -s ipinfo.io/$result)

# Check if "org" contains "Amazon"
if [[ $curl_result == *"Amazon"* ]]; then
    echo -e "\e[32m您的VPS未使用DNS解锁流媒体！\e[0m"
else
    echo -e "\e[31m警告：您的VPS可能使用DNS解锁流媒体！\e[0m"
fi
