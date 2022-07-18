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
docker run --rm -v ros-pylon-setup:/setup zhuoqiw/ros-pylon
sudo docker cp pylon:/setup_host/opt /
/var/lib/docker/volumes/ros-pylon-setup/_data/opt/pylon/share/pylon/setup-usb.sh # follow interactive instruction
sudo rm -r /opt/pylon # in case to save a little bit tiny disk usage
sudo udevadm control --reload-rules # or reboot
```

## For container (multistage built image typically)

Three pieces of information should be setup properly on container:

1. Copy the runtime package from /setup/opt/pylon to container's /opt/pylon
1. Setup PYLON_ROOT to enable easy examples
1. Copy ldconfig from /setup/etc/ld.so.conf.d/pylon.conf to container's /etc/ld.so.conf.d/pylon.conf and run ldconfig

```Dockerfile
FROM zhuoqiw/ros-pylon AS pylon

FROM something-else

COPY --from=pylon /setup /
ENV PYLON_ROOT=/opt/pylon
RUN ldconfig
```
