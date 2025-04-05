### Tuya-convert

- Get tasmota bin
- `systemctl stop systemd-resolved` (using port `53`)
- `sudo btop` and kill `dnsmasq` (using port 53, part of libvirtd)
- Disable the firewall temporarily: `systemctl stop firewall`
- `docker compose run --rm tuya`
- Follow instructions

Also see: 
- https://github.com/ct-Open-Source/tuya-convert
- https://github.com/arendst/Tasmota


## Device links
- https://templates.blakadder.com/feit_electric-DIM-WIFI.html
- https://templates.blakadder.com/ce_smart_home-WF500D.html
- https://templates.blakadder.com/teckin_SP10.html
- https://templates.blakadder.com/bright_741235077572.html
- (Bricked, needs serial flash) https://templates.blakadder.com/bright_741235077565.html

