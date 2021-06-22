#!/usr/bin/env bash

SCENARIO_PATH=$1
SERVICE_A_EXIT_CODE=$2

PURPLE='\033[0;35m'
NC='\033[0m' # No Color

clean_up() {
    mkdir -p $SCENARIO_PATH/results
    screencapture $SCENARIO_PATH/results/exit-$SERVICE_A_EXIT_CODE-pure-systemctl-output.png
    
    clear

    echo ">>> Noting status of service A..."
    docker exec -it $CID /bin/sh -c 'systemctl status a'

    echo ">>> Noting status of service B..."
    docker exec -it $CID /bin/sh -c 'systemctl status b'

    screencapture $SCENARIO_PATH/results/exit-$SERVICE_A_EXIT_CODE-pure-systemctl-status.png

    echo -e "\n>>> Killing container $CID"
    docker kill $CID
}
trap clean_up EXIT

clear

echo -e ">>> Running ${PURPLE}pure systemctl${NC} test ${PURPLE}$SCENARIO_PATH${NC} with service A exit code set to ${PURPLE}$SERVICE_A_EXIT_CODE${NC}"

echo ">>> Building image..."
ID=$(docker build --build-arg SCENARIO_PATH=$SCENARIO_PATH --build-arg SERVICE_A_EXIT_CODE=$SERVICE_A_EXIT_CODE -q -f Dockerfile.pure-systemctl .)

echo ">>> Running container..."
CID=$(docker run -d -it --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro $ID)

echo -e ">>> Following logs for $CID...\n"
docker logs $CID -f 