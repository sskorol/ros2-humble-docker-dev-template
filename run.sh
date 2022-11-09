#!/bin/bash

help()
{
    echo ""
    echo "Usage: $0 -w dev_ws -t sskorol/ros2-humble-dev -b"
    echo -e "\t-w Workspace folder name (relative to $HOME on host and /root in docker)"
    echo -e "\t-i Image to build/run"
    echo -e "\t-b Build mode"
    echo -e "\t-r Run mode"
    echo -e "\t-h Show help"
    exit 1
}

while getopts "w:i:hbr" opt
do
    case "$opt" in
      w) workspace="$OPTARG" ;;
      i) image="$OPTARG" ;;
      b) should_build=true ;;
      r) should_run=true ;;
      h | ?) help ;;
    esac
done

if [[ -z "$workspace" ]]; then
    echo "Workspace folder is mandatory"
    help
fi

if [[ -z "$image" ]]; then
    echo "Image is mandatory"
    help
fi

if [[ -z "$should_build" ]]; then
    should_build=false
fi

if [[ -z "$should_run" ]]; then
    should_run=false
fi

if [[ "$should_build" == false && "$should_run" == false ]] || [[ "$should_build" == true && "$should_run" == true ]]; then
    echo "You must specify either a build(-b) or run(-r) mode"
    help
elif [[ "$should_run" == true ]]; then
    mkdir -p $HOME/$workspace
    xhost +local:docker
    docker run -it \
               --rm \
               --net=host \
               --privileged \
               --gpus=all \
               -e DISPLAY=$DISPLAY \
               -e PYTHONBUFFERED=1 \
               -v /etc/timezone:/etc/timezone:ro \
               -v /etc/localtime:/etc/localtime:ro \
               -v $HOME/$workspace:/root/$workspace:rw \
               -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
               -v $HOME/.Xauthority:/root/.Xauthority:ro \
               -v $PWD/.session.yml:/root/.session.yml \
               -v $PWD/.tmux.conf:/root/.tmux.conf \
               --device=/dev/bus/usb:/dev/bus/usb \
               $image
elif [[ "$should_build" == true ]]; then
   docker build --build-arg WORKSPACE=$workspace -t $image .
fi
