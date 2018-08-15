#!/bin/bash
echo "********************************"
echo "* GlimpseCam Livestream Script *"
echo "* Developed by Tianhao Zhang   *"
echo "* Copyright (C) 2018           *"
echo "********************************"
echo ""
echo "NOTE:"
echo "PLEASE PUT THIS SCRIPT INTO HOME DIRECTORY"
echo "PLEASE GOTO http://LOCALHOST:8080 TO VIEW THE LIVESTREAM"
echo ""

if [ $# -eq 0 ]; then
        echo "Would you like to Install or Launch (if already installed) the livestream? "
        echo "(1) Install the Glimpsecam Livestream Package"
        echo "(2) Launch the Livestream"
        read -p "Please Enter Your Selection (1,2): " ANSWER
else
        ANSWER=$1
fi

if [[ $ANSWER != [1-2] ]]; then
        echo "INVALID SELECTION!"
        exit 1
fi

# Install Glimpsecam Livestream Package
if [ $ANSWER -eq 1 ]; then
	cd /home/pi
	mkdir projects
	cd projects
	sudo apt-get install git
	git clone https://github.com/tianhz2/mjpg-streamer.git
	cd mjpg-streamer/mjpg-streamer-experimental/
	sudo apt-get install cmake
	sudo apt-get install python-imaging
	sudo apt-get install libjpeg-dev
	make CMAKE_BUILD_TYPE=Debug
	sudo make install
	export LD_LIBRARY_PATH=.
fi

# Launch the Livestream
cd /home/pi/projects/mjpg-streamer/mjpg-streamer-experimental/
if [ $# -eq 4 ]; then
	./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -x $2 -y $3 -fps $4 -ex night"
else
	read -p "Please enter the desired width for Livestream Image: " WIDTH
	read -p "Please enter the desired height for Livestream Image: " TALL
	read -p "Please enter the frame rate for Livestream Image: " FPS
	./mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -x $WIDTH -y $TALL -fps $FPS -ex night"
fi
