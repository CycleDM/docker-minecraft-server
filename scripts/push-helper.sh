#!/bin/bash
server_type=$1
game_version=$2
latest_tag=$3
work_dir=$(dirname $(dirname $(readlink -f "$0")))

# 检查参数
if [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit 126
fi

########################################################################################
unset result
docker push cycledm/mcserver-$server_type:$game_version
result=$?
if [ "$result" = "0" ]; then
    echo "cycledm/mcserver-$server_type:$game_version 推送成功"
else
    echo "cycledm/mcserver-$server_type:$game_version 推送失败"
    echo "参数 $1, $2"
    exit 1
fi
if [ ! "$latest_tag" ]; then
    exit 0
fi

docker push cycledm/mcserver-$server_type:$latest_tag
result=$?
if [ "$result" = "0" ]; then
    echo "cycledm/mcserver-$server_type:$latest_tag 推送成功"
else
    echo "cycledm/mcserver-$server_type:$latest_tag 推送失败"
    echo "参数 $1, $2"
    exit 1
fi
########################################################################################