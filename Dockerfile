# Install pylon on ROS
FROM ubuntu:latest

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG URL_AMD=https://github.com/zhuoqiw/ros-pylon/releases/download/v6.2.0/pylon_6.2.0.21487_x86_64_setup.tar.gz
ARG TAR_AMD=pylon_6.2.0.21487_x86_64.tar.gz

# For arm64
ARG URL_ARM=https://github.com/zhuoqiw/ros-pylon/releases/download/v6.2.0/pylon_6.2.0.21487_aarch64_setup.tar.gz
ARG TAR_ARM=pylon_6.2.0.21487_aarch64.tar.gz

# Prepare install directories: package and ldconfig on client, env setup script on host
RUN mkdir -p /setup_client/opt/pylon /setup_client/etc/ld.so.conf.d /setup_host/opt/pylon/share/pylon

# Copy cmake package files
COPY pylon-config*.cmake /setup_client/opt/pylon/

# Install dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Extract package to client
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    wget -O pylon.tar.gz ${URL_AMD} --no-check-certificate \
    && tar -xzf pylon.tar.gz \
    && tar -C /setup_client/opt/pylon -xzf ${TAR_AMD}; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    wget -O pylon.tar.gz ${URL_ARM} --no-check-certificate \
    && tar -xzf pylon.tar.gz \
    && tar -C /setup_client/opt/pylon -xzf ${TAR_ARM}; \
    else exit 1; fi \
    && rm pylon* INSTALL

# Update ldconfig to client
RUN echo "/opt/pylon/lib" >> /setup_client/etc/ld.so.conf.d/pylon.conf

# Copy env setup script to host
RUN cp /setup_client/opt/pylon/share/pylon /setup_host/opt/pylon/share/pylon