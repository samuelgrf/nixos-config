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
sudo nixos-generate-config --dir /etc/nixos.bak
cp /etc/nixos.bak/hardware-configuration.nix /etc/nixos/host/hardware.nix
```

#### Setup Home Manager:
```
mkdir -p ~/.config/nixpkgs
ln -s /etc/nixos/common/home.nix ~/.config/nixpkgs
nix-channel --add https://github.com/rycee/home-manager/archive/release-20.03.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch
```
