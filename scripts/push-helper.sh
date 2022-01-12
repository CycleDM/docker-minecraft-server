#!/bin/bash
server_type=$1
game_version=$2
add_tag=$3
work_dir=$(dirname $(dirname $(readlink -f "$0")))
image_name="cycledm/mcserver-$server_type"

# 检查参数
if [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit 126
fi

########################################################################################
unset result
docker push $image_name$server_type:$game_version
result=$?
if [ "$result" = "0" ]; then
    echo "$image_name$server_type:$game_version 推送成功"
else
    echo "$image_name$server_type:$game_version 推送失败"
    echo "参数 $1, $2"
    exit 1
fi
if [ ! "$add_tag" ]; then
    exit 0
fi

docker push $image_name$server_type:$add_tag
result=$?
if [ "$result" = "0" ]; then
    echo "$image_name$server_type:$add_tag 推送成功"
else
    echo "$image_name$server_type:$add_tag 推送失败"
    echo "参数 $1, $2"
    exit 1
fi
########################################################################################