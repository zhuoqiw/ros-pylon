# ros-pylon

In order to use containerized pylon, this specific image is to be utilized as two roles: for host and container.

## For host

To fully use pylon, four pieces of infomation should be setup properly on host:

1. udev rule
1. usb-ids database (optional)
1. limit of USB memory (optional)
1. limit of open files (optional)

These may be accomplished via a mount point '/setup', follow these steps:

```bash
# run this image once so the setup volume (via mount point) persists
docker run --rm -v ros-pylon-setup:/setup zhuoqiw/ros-pylon

# launch the setup script and follow the interactive instructions
sudo /var/lib/docker/volumes/ros-pylon-setup/_data/opt/pylon/share/pylon/setup-usb.sh

# optional, in case to save a little bit disk usage
docker volume rm ros-pylon-setup

# optional, reboot otherwise
sudo udevadm control --reload-rules
```

## For container (multistage built image typically)

Two pieces of information should be setup properly on container:

1. Copy the runtime package from /setup/opt/pylon to container's /opt/pylon
1. Copy ldconfig from /setup/etc/ld.so.conf.d/pylon.conf to container's /etc/ld.so.conf.d/pylon.conf and run ldconfig

```Dockerfile
FROM zhuoqiw/ros-pylon AS pylon

FROM something-else

COPY --from=pylon /setup /
RUN ldconfig
```
