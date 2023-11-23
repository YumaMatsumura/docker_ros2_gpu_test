FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

LABEL maintainer="yumapine@gmail.com"

ENV ROS_DISTRO=iron

ENV DEBIAN_FRONTEND=noninteractive
ENV __NV_PRIME_RENDER_OFFLOAD=1
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia

RUN apt update && \
    apt install -y vim \
                   git \
                   screen \
                   curl \
                   gnupg2 \
                   lsb-release && \
    rm -rf /var/lib/apt/lists/*

ENV UBUNTU_CODENAME=focal
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

RUN apt update && \
    apt install -y ros-$ROS_DISTRO-desktop \
                   ros-$ROS_DISTRO-xacro \
                   ros-$ROS_DISTRO-gazebo-* \
                   ros-$ROS_DISTRO-rqt-* \
                   gazebo \
                   python3-colcon-common-extensions && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/ros2_ws/src
WORKDIR /root/ros2_ws/
RUN /bin/bash -c '. /opt/ros/iron/setup.bash; colcon build'

COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
