#!/usr/bin/env bash

APOLLO_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "${APOLLO_ROOT_DIR}/scripts/apollo_base.sh"

function localization_msf(){
	echo "Running localization MSF demo."
	source "${APOLLO_ROOT_DIR}/ros_pkgs/devel/setup.bash"
        bash "${APOLLO_ROOT_DIR}/scripts/localization.sh" stop
        echo "localization_type: MSF" > ${APOLLO_ROOT_DIR}/modules/localization/conf/localization_config.pb.txt
	if [ $? -eq 0 ]; then
    	echo "Starting rosbridge..."
    	roslaunch rosbridge_server rosbridge_websocket.launch >/dev/null 2>&1 &
	else
    	error "Failed to source ros_pkgs. Has it been built?"
	fi
	bash "${APOLLO_ROOT_DIR}/scripts/localization.sh"
	#bash "${APOLLO_ROOT_DIR}/scripts/localization_online_visualizer.sh"
	# echo "Launched localization. Please start the simulator and ensure that the lidar and GPS are switched on."
}

function localization_rtk(){
	echo "Running localization RTK demo."
	source "${APOLLO_ROOT_DIR}/ros_pkgs/devel/setup.bash"
        bash "${APOLLO_ROOT_DIR}/scripts/localization.sh" stop
        echo "localization_type: RTK" > ${APOLLO_ROOT_DIR}/modules/localization/conf/localization_config.pb.txt
	if [ $? -eq 0 ]; then
    	echo "Starting rosbridge..."
    	roslaunch rosbridge_server rosbridge_websocket.launch >/dev/null 2>&1 &
	else
    	error "Failed to source ros_pkgs. Has it been built?"
	fi
	bash "${APOLLO_ROOT_DIR}/scripts/localization.sh"
	bash "${APOLLO_ROOT_DIR}/scripts/localization_online_visualizer.sh"
	# echo "Launched localization. Please start the simulator and ensure that the lidar and GPS are switched on."
}

function perception(){
	echo "Running perception demo."
	source "${APOLLO_ROOT_DIR}/ros_pkgs/devel/setup.bash"
	if [ $? -eq 0 ]; then
    	echo "Starting rosbridge..."
    	roslaunch rosbridge_server rosbridge_websocket.launch >/dev/null 2>&1 &
    	echo "Starting image converter..."
    	rosrun simulator_image_converter simulator_image_converter &
	else
    	error "Failed to source ros_pkgs. Has it been built?"
	fi
	bash "${APOLLO_ROOT_DIR}/scripts/bootstrap.sh"
	source "${APOLLO_ROOT_DIR}/scripts/perception_offline_visualizer.sh"

}

case $1 in
  localization_msf)
    localization_msf
    ;;
  localization_rtk)
    localization_rtk
    ;;
  perception)
    perception
    ;;
  *)
    echo "Did not enter demo name."
    ;;
esac
