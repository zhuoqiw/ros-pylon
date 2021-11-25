# Install pylon on ROS
FROM ros:galactic

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# For amd64
ARG URL_AMD=https://github.com/zhuoqiw/ros-pylon/releases/download/v6.2.0/pylon_6.2.0.21487_x86_64_setup.tar.gz
ARG TAR_AMD=pylon_6.2.0.21487_x86_64.tar.gz

# For arm64
ARG URL_ARM=https://github.com/zhuoqiw/ros-pylon/releases/download/v6.2.0/pylon_6.2.0.21487_aarch64_setup.tar.gz
ARG TAR_ARM=pylon_6.2.0.21487_aarch64.tar.gz

# Copy cmake package files
COPY pylon.pc /opt/pylon/lib/pkgconfig

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
  wget -O pylon.tar.gz ${URL_AMD} --no-check-certificate \
  && tar -xzf pylon.tar.gz \
  && tar -C /opt/pylon -xzf ${TAR_AMD}; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
  wget -O pylon.tar.gz ${URL_ARM} --no-check-certificate \
  && tar -xzf pylon.tar.gz \
  && tar -C /opt/pylon -xzf ${TAR_ARM}; \
  else exit 1; fi \
  && cp /opt/pylon/lib/pkgconfig/pylon.pc /usr/lib/pkgconfig/ \
  && rm pylon* INSTALL
