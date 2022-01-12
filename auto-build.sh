#!/bin/bash
work_dir=$(dirname $(readlink -f "$0"))
build_script=$work_dir/scripts/build-helper.sh
push_script=$work_dir/scripts/push-helper.sh

while read line
do
    if [ ! "$line" ]; then 
        continue
    fi
    echo "即将开始构建 $line"
    sh $build_script $line
    sh $push_script ${line#*jre* }
done < $work_dir/auto-build-list

echo "自动构建列表全部完成，即将自动清理镜像..."
sleep 10s
docker image prune -f