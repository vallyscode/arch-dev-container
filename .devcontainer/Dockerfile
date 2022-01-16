ARG VARIANT="latest"
FROM archlinux:${VARIANT}

COPY scripts/* /tmp/scripts/

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN sh /tmp/scripts/setup.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" && \
    rm -rf /tmp/scripts