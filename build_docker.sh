#!/bin/bash

trap ctrl_c INT QUIT TERM

function ctrl_c {
    exit
}

function help {
    echo "usage: ./build_docker.sh [<options>]"
    echo "  this program runs building docker for ros2_gpu_test"
    echo ""
    echo "options:"
    echo "  -h    show this help message and exit"
}

function blue_echo {
    echo -en "\033[36m"
    echo $1
    echo -en "\033[0m"
}

function red_echo {
    echo -en "\033[31m"
    echo $1
    echo -en "\033[0m"
}

function prebuild_docker {
    blue_echo "### prebuild ros2"
    docker build -t ros2 --file Dockerfile .
    if [ $? -ne 0 ]; then
        red_echo "failed to prebuild ros2"
        exit 1
    fi
}

function build_docker {
    blue_echo "### build rviz2 and gazebo"
    docker compose run --rm rviz2-test bash -c "cd /root/ros2_ws && colcon build" && \
    docker compose run --rm gazebo-test bash -c "cd /root/ros2_ws && colcon build"
    if [ $? -ne 0 ]; then
        red_echo "failed to build rviz2 and gazebo"
        exit 1
    fi
}

while getopts h option; do
    case ${option} in
        h)
            help
            exit
            ;;
        *)
            ;;
    esac
done

prebuild_docker
build_docker
