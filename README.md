# ros-pylon

In order to use containerized pylon, this specific image is to be utilized as two roles: for host and client.

## For host

To fully use pylon, four pieces of infomation should be setup properly on host:

1. udev rule
1. usb-ids database (optional)
1. limit of USB memory (optional)
1. limit of open files (optional)

These may be accomplished in one script, follow these steps:

```bash
docker run --name pylon zhuoqiw/ros-pylon
sudo docker cp pylon:/setup_host/opt /
/opt/pylon/share/pylon/setup-usb.sh # follow interactive instruction
docker rm pylon
sudo rm -r /opt/pylon # in case to save a little bit tiny disk usage
sudo udevadm control --reload-rules # or reboot
```

## For client (multistage built image typically)

Two pieces of information should be setup properly on client:

1. Copy the runtime package from /setup_client/opt/pylon to client's /opt/pylon
1. Copy ldconfig from /setup_client/etc/ld.so.conf.d/pylon.conf to client's /etc/ld.so.conf.d/pylon.conf and run ldconfig

```Dockerfile
FROM zhuoqiw/ros-pylon AS pylon

COPY --from=pylon /setup_client/opt/pylon /opt/pylon
COPY --from=pylon /setup_client/etc/ld.so.conf.d/pylon.conf /etc/ld.so.conf.d/pylon.conf
RUN ldconfig
```
