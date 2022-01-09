FROM alpine:latest AS builder

ARG SERVER_TYPE="none"
ARG GAME_VERSION=1.18.1
ARG MAX_RAM=4G
ARG JVM_PARAM="-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+ParallelRefProcEnabled"

RUN apk add --no-cache --virtual .buildPacks wget git && \
    mkdir /temp && \
    cd /temp && \
    # Download scripts
    wget "https://raw.githubusercontent.com/CycleDM/docker-minecraft-server/main/scripts/download.sh" && \
    wget "https://raw.githubusercontent.com/CycleDM/docker-minecraft-server/main/scripts/init.sh" && \
    chmod a+x download.sh init.sh && \
    sh download.sh $SERVER_TYPE $GAME_VERSION && \
    echo "eula=false" > eula.txt && \
    echo "sed -i 's/false/true/g' eula.txt" > start.sh && \
    echo "exec java -Xmx$MAX_RAM $JVM_PARAM -jar $(ls *.jar) nogui" >> start.sh && \
    chmod a+x start.sh && \
    apk del .buildPacks

FROM cycledm/dragonwell:jre17

ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.utf8

COPY --from=builder /temp /resource

WORKDIR /app

ENTRYPOINT ["sh", "/resource/init.sh"]