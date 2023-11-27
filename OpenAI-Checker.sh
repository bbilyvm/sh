#!/bin/bash

# 设置终端为非缓冲模式
export TERM=ansi

Font_Green="\033[32m"
Font_Red="\033[31m"
Font_Suffix="\033[0m"

check_vpn() {
    url=$1
    keyword=$2
    type=$3

    # 发送请求并获取页面内容
    response=$(curl -s "$url")

    # 检查页面内容是否包含关键字
    if echo "$response" | grep -q "$keyword"; then
        echo -e "\r %-20s:\tNo" "${type}_ChatGPT" >> output.log
    else
        echo -e "\r %-20s:\tYes" "${type}_ChatGPT" >> output.log
    fi
}

# 清空输出文件
> output.log

# 检查 Web ChatGPT
check_vpn "https://chat.openai.com/" "VPN" "Web"

# 检查 iOS ChatGPT
check_vpn "https://ios.chat.openai.com/" "VPN" "iOS"

# 检查 Android ChatGPT
check_vpn "https://android.chat.openai.com/" "VPN" "Android"

# 在终端中显示带颜色的输出
cat output.log | sed -e "s/No/${Font_Red}No${Font_Suffix}/" -e "s/Yes/${Font_Green}Yes${Font_Suffix}/"
