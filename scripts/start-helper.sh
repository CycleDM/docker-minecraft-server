#!/bin/bash
work_dir=/app

copyResources()
{
    if [ ! -d "$work_dir" ]; then
        mkdir $work_dir
    fi
    echo "Copying files to $work_dir..."
    # Server .jar file
    cp -rf /resource/*.jar $work_dir/
    # Start shell
    cp -rf /resource/start.sh $work_dir/
    # Mojang EULA
    cp -rf /resource/eula.txt $work_dir/
    echo "File copy finished."
}

startServer()
{
    cd $work_dir
    exec sh start.sh
}

# 工作目录不存在或者没有jar文件时自动拷贝至工作目录
# "--override"参数代表运行时强制覆盖运行文件，总是拷贝
if [ ! -d "$work_dir" ] || [ ! `ls -A $work_dir | grep -Eo '.+\.jar'` ] || [ "$1" = "--override" ]; then
    copyResources
fi

startServer