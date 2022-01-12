#!/bin/bash
work_dir=$(dirname $(readlink -f "$0"))
build_script=$work_dir/scripts/build-helper.sh
push_script=$work_dir/scripts/push-helper.sh

while read line
do
    echo $line
    sh $build_script $line
    sh $push_script ${line#*jre* }
done < $work_dir/auto-build-list

docker image prune -f