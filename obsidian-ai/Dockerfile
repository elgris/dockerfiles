FROM node:26-alpine3.23

ARG USERNAME=node

RUN npm install -g @earendil-works/pi-coding-agent

# Set up the internal directories
RUN mkdir -p /home/${USERNAME}/.pi /workspace && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.pi /workspace

USER ${USERNAME}
WORKDIR /workspace

# Keep the container alive indefinitely in the background
CMD ["sleep", "infinity"]