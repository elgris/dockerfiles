FROM node:26-alpine3.23

ARG USERNAME=pi
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN addgroup -g $USER_GID $USERNAME && \
    adduser -u $USER_UID -G $USERNAME -s /bin/bash -D $USERNAME

RUN apk add --no-cache bash && \
  npm install -g --ignore-scripts @earendil-works/pi-coding-agent

RUN mkdir -p /home/$USERNAME/.pi/agent/skills \
            /home/$USERNAME/.agents/skills \
            /workspace && \
    chown -R $USERNAME:node /home/$USERNAME /workspace

USER $USERNAME

WORKDIR /workspace

ENTRYPOINT ["pi"]