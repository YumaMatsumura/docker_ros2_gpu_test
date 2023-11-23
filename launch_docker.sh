#!/bin/bash

is_launched_rviz2=false
debug=0

trap ctrl_c INT QUIT TERM

function ctrl_c {
    docker_compose_down
    exit
}

function help {
    echo "usage: ./launch_docker.sh [<options>]"
    echo "  this program runs launching docker for ros2_gpu_test"
    echo ""
    echo "options:"
    echo "  -h           show this help message and exit"
    echo "  -d           debug option"
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

function docker_compose_up {
    debug_option=
    if [ ${debug} -eq 1 ]; then
        debug_option='-d'
    fi

    xhost local:
    docker compose up ${debug_option}
    eval "$1=true"
}

function docker_compose_down {
    if ! ${is_launched_rviz2}; then
        docker compose down
    fi
}

while getopts hd option; do
    case ${option} in
        h)
            help
            exit
            ;;
        d)
            debug=1
            ;;
        *)
            ;;
    esac
done

if docker_compose_up ${is_launched_rviz2}; then
    blue_echo "successfully started rviz2 and gazebo"
else
    red_echo "failed to bringup rviz2 and gazebo"
fi
