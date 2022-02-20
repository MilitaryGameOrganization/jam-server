#!/bin/bash

# shellcheck disable=SC2172

trap '
    echo "server stopping..." >&2;
    {
        /rcon-cli/rcon-cli --address localhost:25575 --password rcon "say server stopping in 5 seconds";
        sleep 5;
        /rcon-cli/rcon-cli --address localhost:25575 --password rcon save-all;
        /rcon-cli/rcon-cli --address localhost:25575 --password rcon stop
    } || {
        echo "cannot use stop command; fall back to kill command" >&2;
        kill $pid
    };
    wait $pid
' TERM INT

HEAP="${HEAP:-16G}"
PAUSE="${PAUSE:-100}"

mkdir -p /save/world
mkdir -p /save/logs
mkdir -p /save/crash-reports

java -Xms"$HEAP" -XX:MetaspaceSize=2048m -XX:MaxMetaspaceSize=2048m \
    -XX:+OptimizeStringConcat -XX:+AggressiveOpts \
    -XX:+UseStringDeduplication -XX:+DisableExplicitGC -XX:+UseBiasedLocking \
    -XX:+UseG1GC -XX:MaxGCPauseMillis="$PAUSE" -XX:ParallelGCThreads=10 \
    -Dfml.queryResult=confirm \
    -verbose:gc -XX:+PrintGCDateStamps \
    -Xloggc:logs/gc-$(date --iso-8601=seconds | sed 's/[-:T+]//g').log \
    -jar mohist.jar nogui \
    < /dev/stdin > /dev/stdout &

pid=$!

wait $pid
