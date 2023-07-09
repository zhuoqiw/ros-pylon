# Extract pylon
FROM ubuntu:latest AS base

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG URL_AMD=https://www.baslerweb.com/fp-1682511097/media/downloads/software/pylon_software/pylon_7.3.0.27189_linux-x86_64_setup.tar.gz

# For arm64
ARG URL_ARM=https://www.baslerweb.com/fp-1682511094/media/downloads/software/pylon_software/pylon_7.3.0.27189_linux-aarch64_setup.tar.gz

# Prepare install directories
RUN mkdir -p /setup/opt/pylon /setup/etc/ld.so.conf.d

# Install dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Extract package to client
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    wget -O temp.tar.gz ${URL_AMD} --no-check-certificate \
    && tar -xzf temp.tar.gz \
    && tar -C /setup/opt/pylon -xzf pylon_*.tar.gz; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    wget -O temp.tar.gz ${URL_ARM} --no-check-certificate \
    && tar -xzf temp.tar.gz \
    && tar -C /setup/opt/pylon -xzf pylon_*.tar.gz; \
    else exit 1; fi \
    && chmod 755 /setup/opt/pylon

# Update ldconfig to client
RUN echo "/opt/pylon/lib" >> /setup/etc/ld.so.conf.d/pylon.conf

# Use busybox as container
FROM busybox:latest

# Copy
COPY --from=base /setup/* /setup

# Mount point for image users to install udev rules, etc.
VOLUME [ "/setup" ]
