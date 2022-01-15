#!/bin/bash

export UNOBTANIUMD_PATH=${UNOBTANIUMD_PATH:="/root/.unobtanium/"}
export RPC_HOST=${RPC_HOST:="127.0.0.1"}

# Run "setup.py develop" if we need to
if [ ! -d /armory-utxsvr/armory_utxsvr.egg-info ]; then
    cd /armory-utxsvr; python3 setup.py develop; cd /
fi

# Launch, utilizing the SIGTERM/SIGINT propagation pattern from
# http://veithen.github.io/2014/11/16/sigterm-propagation.html
: ${PARAMS:=""}
trap 'kill -TERM $PID' TERM INT
UNOBTANIUMD_PATH=${UNOBTANIUMD_PATH} RPC_HOST=${RPC_HOST} DISPLAY=localhost:1.0 xvfb-run --auto-servernum /usr/local/bin/armory-utxsvr ${PARAMS} $UNOBTANIUMD_URL &
PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?
