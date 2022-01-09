#!/bin/bash
type=$1
version=$2
build_version=latest
if [ ! "$type" ]; then
    exit
fi

# papermc.io
paper_api="https://papermc.io/api/v2/projects/paper/versions/$version"
paper_url="$paper_api/builds/$build_version/downloads/paper-$version-$build_version.jar"
if [ "$type" = "paper" ]; then
    wget -O api_string $paper_api
    build_version=$(cat api_string |grep -Eo '[0-9]+' |tail -1)
    # Reset download url (as "latest" is unvaliable for PaperMC)
    paper_url="$paper_api/builds/$build_version/downloads/paper-$version-$build_version.jar"
    wget --content-disposition $paper_url
    rm api_string
    exit
fi

# purpurmc.org
purpur_api="https://api.purpurmc.org/v2/purpur/$version"
purpur_url="$purpur_api/$build_version/download"
if [ "$type" = "purpur" ]; then
    wget -O api_string $purpur_api
    build_version=$(cat api_string |grep -Eo '\<latest.+[0-9]+\"' |grep -Eo '[0-9]+' |head -n1)
    # Reset download url
    purpur_url="$purpur_api/$build_version/download"
    wget --content-disposition $purpur_url
    rm api_string
    exit
fi

# spigotmc.org
spigot_builder="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
temp=$(echo $version |grep -Eo '[0-9]+'| sed -n '2p')

if [ "$type" = "spigot" ]; then
    mkdir build && cd build
    wget -O BuildTools.jar $spigot_builder
    if [ "$temp" -gt "16" ]; then
        # Java 17
        java17 -jar BuildTools.jar --rev "$version" --output-dir ../
    else
        # Java 8
        java8 -jar BuildTools.jar --rev "$version" --output-dir ../
    fi
    # Clean
    cd .. && rm -rf build
    exit
fi

# mohistmc.com
mohist_api="https://mohistmc.com/api/$version"
mohist_url="$mohist_api/$build_version/download"
if [ "$type" = "mohist" ]; then
    wget --content-disposition $mohist_url
    exit
fi