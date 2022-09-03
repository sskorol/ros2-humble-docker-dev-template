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
    curl \
    gazebo \
    nano \
    ruby-dev \
    rviz \
    tmux \
    wget \
    zsh

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
RUN echo "source /opt/ros/humble/setup.zsh" >> /root/.zshrc
RUN chmod 0700 /tmp

CMD [ "tmuxinator", "start", "-p", "/root/.session.yml" ]
