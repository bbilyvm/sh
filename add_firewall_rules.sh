#!/bin/bash

# 提示用户输入IP地址
read -p "请输入要允许访问的IP地址: " allowed_ip

# 检查是否输入了IP地址
if [ -z "$allowed_ip" ]; then
  echo -e "\e[31m未提供有效的IP地址。脚本终止。\e[0m"
  exit 1
fi

# 定义要允许的端口
allowed_ports=("53" "80" "443")

# 循环遍历端口，并添加防火墙规则
for port in "${allowed_ports[@]}"; do
  ufw allow from "$allowed_ip" to any port "$port"
done

echo -e "\e[32m防火墙规则添加成功！\e[0m"
