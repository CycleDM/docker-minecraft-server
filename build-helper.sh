#!/bin/bash
jre_version=$1
server_type=$2
game_version=$3
work_dir=$(dirname $(readlink -f "$0"))

# 检查参数
if [ ! "$jre_version" ] || [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit 126
fi

########################################################################################
cp $work_dir/dockerfile/Dockerfile $work_dir

docker pull cycledm/dragonwell:$jre_version
sed -i "s/cycledm\/dragonwell:jre17/cycledm\/dragonwell:$jre_version/g" $work_dir/Dockerfile
#nohub docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t cycledm/mcserver-$server_type:$game_version $work_dir >build-$server_type-$game_version.log 2>&1 &
docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t cycledm/mcserver-$server_type:$game_version $work_dir
if [ "$?" = "0" ]; then
    echo "cycledm/mcserver-$server_type:$game_version 构建成功"
    rm $work_dir/Dockerfile
    exit 0
else
    echo "cycledm/mcserver-$server_type:$game_version 构建失败"
    echo "参数 $1, $2, $3"
    rm $work_dir/Dockerfile
    exit 1
fi
########################################################################################