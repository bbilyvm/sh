#!/bin/bash

# 检查是否安装了 UFW
if ! command -v ufw &> /dev/null; then
  echo -e "\e[31m未检测到UFW防火墙。正在安装...\e[0m"
  sudo apt-get update
  sudo apt-get install -y ufw
  sudo ufw enable
  sudo ufw default deny
  sudo ufw allow 22/tcp
  sudo ufw allow 22222/tcp
  echo -e "\e[32mUFW防火墙已安装并启用，初始规则已设置。\e[0m"
fi

# 提示用户输入IP地址
read -p "请输入要允许访问的IP地址: " allowed_ip

# 验证输入是否为有效的IP地址
if [[ ! $allowed_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo -e "\e[31m无效的IP地址。脚本终止。\e[0m"
  exit 1
fi

# 定义要允许的端口
allowed_ports=("53" "80" "443")

# 循环遍历端口，并添加防火墙规则
for port in "${allowed_ports[@]}"; do
  sudo ufw allow from "$allowed_ip" to any port "$port"
done

echo -e "\e[32m防火墙规则添加成功！\e[0m"
