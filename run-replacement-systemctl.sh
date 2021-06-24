#!/usr/bin/env bash

source ./shared-consts.sh
source ./shared-funcs.sh

clean_up() {
    capture_results $LOG_RESULTS $SCENARIO_PATH $SERVICE_A_EXIT_CODE $CID
    stop_running_container $CID
}
trap clean_up EXIT

clear

echo -e ">>> Running ${PURPLE}replacement systemctl${NC} test ${PURPLE}$SCENARIO_PATH${NC} with service A exit code set to ${PURPLE}$SERVICE_A_EXIT_CODE${NC}"

echo ">>> Building image..."
ID=$(docker build --build-arg SCENARIO_PATH=$SCENARIO_PATH --build-arg SERVICE_A_EXIT_CODE=$SERVICE_A_EXIT_CODE -q -f Dockerfile.systemctl-replacement .)

echo ">>> Running container..."
CID=$(docker run -d -it $ID)

echo -e ">>> Following logs for $CID...\n"
docker logs -f $CID