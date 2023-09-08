#!/bin/bash

latest_version=""
app_dirs=("/root/Alist/alist_1/" "/root/Alist/alist_2/" "/root/Alist/alist_3/")

start_app() {
    echo "Starting $1..."
    $1 start
}

stop_app() {
    echo "Stopping $1..."
    $1 stop
}

update_app() {
    wget_output=$(wget -qO- -t1 -T2 "https://api.github.com/repos/alist-org/alist/releases/latest")
    latest_version=$(echo "$wget_output" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')

    if [[ -z "$latest_version" ]]; then
        echo "Failed to retrieve latest version."
        exit 1
    fi

    echo "Latest version: $latest_version"
    read -p "Update to version $latest_version? (yes/no): " update_input
    update_input_lower=$(echo "$update_input" | tr '[:upper:]' '[:lower:]')

    if [[ "$update_input_lower" == "yes" || "$update_input_lower" == "y" ]]; then
        for dir in "${app_dirs[@]}"; do
            stop_app "$dir/alist"
        done

        wget "https://github.com/alist-org/alist/releases/download/$latest_version/alist-linux-arm64.tar.gz"
        tar zxf alist-linux-arm64.tar.gz
        chmod +x alist

        for dir in "${app_dirs[@]}"; do
            cp alist "$dir"
        done

        rm alist alist-linux-arm64.tar.gz

        for dir in "${app_dirs[@]}"; do
            start_app "$dir/alist"
        done

        exit 0
    fi
}

# Main script

update_app

read -p "Start Alist? (yes/no): " start_input
start_input_lower=$(echo "$start_input" | tr '[:upper:]' '[:lower:]')
if [[ "$start_input_lower" == "yes" || "$start_input_lower" == "y" ]]; then
    for dir in "${app_dirs[@]}"; do
        start_app "$dir/alist"
    done
fi

read -p "Stop Alist? (yes/no): " stop_input
stop_input_lower=$(echo "$stop_input" | tr '[:upper:]' '[:lower:]')
if [[ "$stop_input_lower" == "yes" || "$stop_input_lower" == "y" ]]; then
    for dir in "${app_dirs[@]}"; do
        stop_app "$dir/alist"
    done
fi
