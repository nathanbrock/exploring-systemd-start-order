#!/usr/bin/env bash

SCENARIO_PATH=$1

# Run tests with exit code 0
./run-pure-systemctl.sh $SCENARIO_PATH 0
./run-replacement-systemctl.sh $SCENARIO_PATH 0

# Run tests with exit code 1
./run-pure-systemctl.sh $SCENARIO_PATH 1
./run-replacement-systemctl.sh $SCENARIO_PATH 1

open ./$SCENARIO_PATH/results