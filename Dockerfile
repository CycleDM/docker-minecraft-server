FROM alpine:latest AS builder

ARG SERVER_TYPE="none"
ARG GAME_VERSION=1.18.1
ARG MAX_RAM=4G
ARG JVM_PARAM="-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+ParallelRefProcEnabled"

COPY ["./scripts/start-helper.sh", "./scripts/download-helper.sh", "/temp/"]

RUN apk add --no-cache --virtual .buildPacks wget git && \
    cd /temp && \
    chmod a+x download-helper.sh start-helper.sh && \
    sh download-helper.sh $SERVER_TYPE $GAME_VERSION && \
    echo "eula=false" > eula.txt && \
    echo "sed -i 's/false/true/g' eula.txt" > start.sh && \
    echo "exec java -Xmx$MAX_RAM $JVM_PARAM -jar $(ls *.jar) nogui" >> start.sh && \
    chmod a+x start.sh && \
    rm download-helper.sh && \
    apk del .buildPacks

FROM cycledm/dragonwell:jre11

ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8

COPY --from=builder /temp /resource

WORKDIR /app

ENTRYPOINT ["sh", "/resource/start-helper.sh"]