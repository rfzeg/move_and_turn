FROM osrf/ros:noetic-desktop-full-focal

# Tell the container to use the C.UTF-8 locale for its language settings
ENV LANG C.UTF-8

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections


# Install required packages
RUN set -x \
    && apt-get update \
    && apt-get --with-new-pkgs upgrade -y \
    && apt-get install -y git \
    && apt-get install -y ros-noetic-turtlebot3 \
    && apt-get install -y ros-noetic-turtlebot3-bringup ros-noetic-turtlebot3-description \
    && apt-get install -y ros-noetic-turtlebot3-example ros-noetic-turtlebot3-gazebo \
    && apt-get install -y ros-noetic-turtlebot3-msgs ros-noetic-turtlebot3-navigation \
    && apt-get install -y ros-noetic-turtlebot3-simulations \
    && apt-get install -y ros-noetic-turtlebot3-slam ros-noetic-turtlebot3-teleop \
    && apt-get install -y ros-noetic-gmapping ros-noetic-slam-gmapping ros-noetic-openslam-gmapping \ 
    && rm -rf /var/lib/apt/lists/*

# Link python3 to python otherwise ROS scripts fail when using the OSRF contianer
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set up the catkin workspace
WORKDIR /
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

COPY ./ /catkin_ws/src/move_and_turn

# build
WORKDIR /catkin_ws

#  Source environments
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc && \
    echo "export TURTLEBOT3_MODEL=waffle" >> /root/.bashrc

# Set up the Network Configuration
# Example with the ROS_MASTER_URI value set as the one running on the Host System
# ENV ROS_MASTER_URI http://1_simulation:11311

# Cleanup
RUN rm -rf /root/.cache

# Entrypoint
#ADD ./turtlebot_docker_sim/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# Add custom launch file
#ADD ./turtlebot_docker_sim/t3_world_headless.launch /catkin_ws/t3_world_headless.launch

#WORKDIR /catkin_ws
#ENTRYPOINT [ "/entrypoint.sh" ]

# Start a bash shell when the container starts
CMD ["bash"]