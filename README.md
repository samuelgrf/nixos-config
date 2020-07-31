nixos-config
============

My [NixOS](https://nixos.org) configuration.

Instructions
------------

### Note: Run all commands as the default user!

#### Set nixos_host variable to a folder in nixos-config/hosts:
```
nixos_host=<name>
```

#### Clone, take ownership and copy generated hardware.nix:
```
sudo mv /etc/nixos /etc/nixos.bak
sudo mkdir /etc/nixos
sudo chown -R $USER\:users /etc/nixos
git clone https://gitlab.com/samuelgrf/nixos-config.git /etc/nixos
ln -s \./hosts/$nixos_host /etc/nixos/host
nixos-generate-config --show-hardware-config > /etc/nixos/host/hardware.nix
```

#### Add and update channels:
```
sudo nix-channel --add https://github.com/rycee/home-manager/archive/release-20.03.tar.gz home-manager
sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
sudo nix-channel --update
```
