#!/usr/bin/env bash
set -e

# ---------------------- Install pyenv for python sanity --------------------- #
curl https://pyenv.run | bash

# --------------------- Update the shell config for bash --------------------- #
# shellcheck disable=SC2016
{
	echo 'export PYENV_ROOT="$HOME/.pyenv"'
	echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
	echo 'eval "$(pyenv init -)"'
} >>~/.bashrc

# --------------------- Install Python build dependencies -------------------- #
sudo apt update -y &&
	sudo apt install -y make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# ------------------------------ Set tmux color ------------------------------ #
echo 'set -g default-terminal "screen-256color"' >>~/.tmux.conf

# ------------------------------- Install CUDA ------------------------------- #
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin &&
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&
	sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub &&
	sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" &&
	sudo apt update -y &&
	sudo apt install -y cuda

# ------------------- Install fabricmanager (for A100 only) ------------------ #
NVIDIA_DRIVER_VERSION=$(dpkg -l | grep nvidia-driver- | cut -d ' ' -f 3 | cut -d '-' -f 3) &&
	sudo apt install -y "cuda-drivers-fabricmanager-$NVIDIA_DRIVER_VERSION" &&
	sudo service nvidia-fabricmanager start

# ------------------------------ Install Docker ------------------------------ #
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
	sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null &&
	sudo apt update -y &&
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# -------------------------- Install nvidia-docker2 -------------------------- #
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
# shellcheck source=/dev/null
distribution=$(
	. /etc/os-release
	echo "$ID""$VERSION_ID"
) && {
	curl -s -L https://nvidia.github.io/libnvidia-container/"$distribution"/libnvidia-container.list |
		sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
		sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
}
sudo apt update -y &&
	sudo apt install -y nvidia-docker2 &&
	sudo systemctl restart docker

# ------------------------------- Restart shell ------------------------------ #
exec "$SHELL"
