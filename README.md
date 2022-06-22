# Prepare Oracle VM

This guide and scripts are for preparing an instance on Oracle. This is a very opinionate approach that works for me.

I made this because it took me ages to figure it out and this is the easiest route I found. This works for me. Your mileage may vary and I'm not taking any responsibility if something breaks. As always, check what you are running before you run it.

## Prerequisites

### OS

**I am using Ubuntu 20.04** I have had issues getting Ubuntu 22.04 working for some reason and it didn't work after some debugging so I'm not going to look into it again for a while.



<!-- ## Creating the Instance

TBA -->

<!-- ## Knowing when it's ready to go

TBA -->

## Installing things

Run the following command to download and run the script:

```bash
curl -s -S -L https://raw.githubusercontent.com/amitkparekh/prepare-oracle-vm/main/bin/oracle-a100.sh | bash
```

### What does the script to?

2. Install [pyenv](https://github.com/pyenv/pyenv)
3. Make the tmux console colourful
4. Install the latest [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_network)
5. Install [Fabric Manager](https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide/index.html) for NVIDIA A100 GPUs[^1]
6. Install [Docker Engine with the Docker Compose plugin](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
7. Install [nvidia-docker2](https://github.com/NVIDIA/nvidia-docker)






[^1]: https://ubuntu.com/blog/installing-nvidia-drivers-on-oracle-cloud
