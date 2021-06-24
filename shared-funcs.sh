#!/usr/bin/env bash

stop_running_container () {
    CID=$1
    echo -e "\n>>> Killing container $CID"
    docker kill $CID
}

capture_results() {
    DONT_LOG_RESULTS=$1
    SCENARIO_PATH=$2
    SERVICE_A_EXIT_CODE=$3
    CID=$4

    if [ "$LOG_RESULTS" != "true" ]; then
        echo -e "\n\n>>> Not capturing results for this run"
        return
    fi
    
    mkdir -p $SCENARIO_PATH/results

    screencapture $SCENARIO_PATH/results/exit-$SERVICE_A_EXIT_CODE-pure-systemctl-output.png
    
    clear

    echo ">>> Noting status of service A..."
    docker exec -it $CID /bin/sh -c 'systemctl status a'

    echo ">>> Noting status of service B..."
    docker exec -it $CID /bin/sh -c 'systemctl status b'

    screencapture $SCENARIO_PATH/results/exit-$SERVICE_A_EXIT_CODE-pure-systemctl-status.png
}