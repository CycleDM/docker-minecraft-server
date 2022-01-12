#!/bin/bash
work_dir=$(dirname $(readlink -f "$0"))
build_script=$work_dir/scripts/build-helper.sh
push_script=$work_dir/scripts/push-helper.sh

docker image prune -f
while read line
do
    echo $line
    sh $build_script $line
    sh $push_script ${line#*jre* }
done < $work_dir/to-build-list