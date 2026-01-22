

## Klipper deps
sudo apt install python3-virtualenv python3-dev libffi-dev build-essential libncurses-dev avrdude gcc-avr binutils-avr avr-libc stm32flash dfu-util libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 libusb-1.0-0-dev

## Moonraker deps
sudo apt install python3-virtualenv python3-dev libopenjp2-7 python3-libgpiod curl libcurl4-openssl-dev libssl-dev liblmdb-dev libsodium-dev zlib1g-dev libjpeg-dev packagekit wireless-tools

## OWRT equivalents

apk add python3 python3-dev python3-venv
apk add ip-full libsodium
apk add gcc
- Needed for cloning git repos via http, not included in base git on owrt
apk add git-http

- Not needed?
python3-tornado python3-distro python3-curl python3-zeroconf python3-paho-mqtt python3-requests python3-cffi

## Setup commands

- `git clone https://github.com/Klipper3d/klipper`
- `python3 -m venv -p python3 ./klippy-env`
- `source ./klippy-env/bin/activate`

