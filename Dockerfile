FROM ros:noetic-ros-base-focal

# make workspace
WORKDIR /
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

# install git
RUN apt-get update && apt-get install -y \
    git

# clone diagnostics repo
RUN git clone https://github.com/ros/diagnostics.git -b noetic-devel

COPY ./ /catkin_ws/src/move_and_turn

ENV ROS_MASTER_URI http://1_simulation:11311

# build
WORKDIR /catkin_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# replace setup.bash in ros_entrypoint.sh
RUN sed -i 's|source "/opt/ros/\$ROS_DISTRO/setup.bash"|source "/catkin_ws/devel/setup.bash"|g' /ros_entrypoint.sh

CMD /bin/bash -c "source /opt/ros/noetic/setup.bash && roscore & roslaunch move_and_turn move_and_turn.launch"