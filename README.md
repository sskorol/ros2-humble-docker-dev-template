## ROS2 Humble - docker dev template

This repo provides a template for a quick start with a ROS2 Humble development in Docker.

<video src="https://user-images.githubusercontent.com/6638780/188269308-48c5b343-f268-408a-9d1a-435417dc9260.mp4"></video>

### Setup

```shell
git clone https://github.com/sskorol/ros2-humble-docker-dev-template.git && cd ros2-humble-docker-dev-template
./run.sh -h
```

![Help](https://user-images.githubusercontent.com/6638780/188268405-82f77eb3-1308-46ba-b6ba-1ef3f956f0af.png)

### Building

```shell
./run.sh -w dev_ws -t [YOUR_IMAGE_NAME:TAG] -b
```

### Running

- Update `.tmux.conf` if you need to enable additional `tmux` features
- Update `.session.yml` to customize Tmuxinator UI

Note that the above configs are mapped as volumes to docker image.

```shell
./run.sh -w dev_ws -t [YOUR_IMAGE_NAME:TAG] -r
```

### Notes

- Mouse is enabled by default
- Use pageup/pagedown keys to switch between `tmux` windows (mouse click also works)
- Press shift key to select the text via mouse
- `tmux` ctrl+b prefix is remapped to ctrl+a
- ctrl+a -> x -> y series closes the `tmux` and docker session
