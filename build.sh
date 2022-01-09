#!/bin/bash
work_dir=$1
server_type=$2
game_version=$3

if [ ! "$work_dir" ] || [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit
fi

nohup docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t cycledm/mcserver-$server_type:$game_version $work_dir >build-$server_type-$game_version.log 2>&1 &
echo "已创建构建任务"