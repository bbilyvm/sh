#!/bin/bash

check_vpn() {
    url=$1
    keyword=$2
    type=$3

    # 发送请求并获取页面内容
    response=$(curl -s "$url")

    # 检查页面内容是否包含关键字
    if echo "$response" | grep -q "$keyword"; then
        echo "${type}_ChatGPT: No"
    else
        echo "${type}_ChatGPT: Yes"
    fi
}

# 检查 Web ChatGPT
check_vpn "https://chat.openai.com/" "VPN" "Web"

# 检查 iOS ChatGPT
check_vpn "https://ios.chat.openai.com/" "VPN" "iOS"

# 检查 Android ChatGPT
check_vpn "https://android.chat.openai.com/" "VPN" "Android"
