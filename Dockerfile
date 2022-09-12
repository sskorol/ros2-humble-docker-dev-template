FROM osrf/ros:humble-desktop-full

ARG WORKSPACE=humble_dev_ws
WORKDIR /root/$WORKSPACE

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ENV QT_X11_NO_MITSHM=1
ENV EDITOR=nano
ENV XDG_RUNTIME_DIR=/tmp

RUN apt-get update && apt-get install -y \
    cmake \
    curl \
    gazebo \
    libglu1-mesa-dev \
    nano \
    python3-pip \
    ros-humble-gazebo-ros \
    ros-humble-joint-state-publisher \
    ros-humble-robot-state-publisher \
    ros-humble-xacro \
    ruby-dev \
    rviz \
    tmux \
    wget \
    xorg-dev \
    zsh

RUN wget https://github.com/openrr/urdf-viz/releases/download/v0.38.2/urdf-viz-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xvzf urdf-viz-x86_64-unknown-linux-gnu.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/urdf-viz && \
    rm -f urdf-viz-x86_64-unknown-linux-gnu.tar.gz

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

RUN gem install tmuxinator && \
    wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O /usr/local/share/zsh/site-functions/_tmuxinator

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN echo "export DISABLE_AUTO_TITLE=true" >> /root/.zshrc
RUN echo 'LC_NUMERIC="en_US.UTF-8"' >> /root/.zshrc
RUN echo "source /opt/ros/humble/setup.zsh" >> /root/.zshrc

CMD [ "tmuxinator", "start", "-p", "/root/.session.yml" ]
