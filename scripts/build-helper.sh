#!/bin/bash
jre_version=$1
server_type=$2
game_version=$3
add_tag=$4
work_dir=$(dirname $(dirname $(readlink -f "$0")))
image_name="cycledm/mcserver-$server_type"

# 检查参数
if [ ! "$jre_version" ] || [ ! "$server_type" ] || [ ! "$game_version" ]; then
    echo "参数缺失"
    exit 126
fi

########################################################################################
docker pull cycledm/dragonwell:$jre_version
cp $work_dir/dockerfile/Dockerfile $work_dir

sed -i "s/cycledm\/dragonwell:jre17/cycledm\/dragonwell:$jre_version/g" $work_dir/Dockerfile
if [ "$add_tag" ]; then
    docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t $image_name:$game_version -t $image_name:$add_tag $work_dir
else
    docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t $image_name:$game_version $work_dir
fi
docker build --build-arg SERVER_TYPE=$server_type --build-arg GAME_VERSION=$game_version -t $image_name:$game_version $work_dir
if [ "$?" = "0" ]; then
    echo "$image_name:$game_version 构建成功"
    rm $work_dir/Dockerfile
    exit 0
else
    echo "$image_name:$game_version 构建失败"
    echo "参数 $1, $2, $3"
    rm $work_dir/Dockerfile
    exit 1
fi
########################################################################################