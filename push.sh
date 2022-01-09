#!/bin/bash
server_type=$1
game_version=$2

if [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit
fi

nohup docker push cycledm/mcserver-$server_type:$game_version >push-$server_type-$game_version.log 2>&1 &
echo "已创建推送任务"