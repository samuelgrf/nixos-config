nixos-config
============

My [NixOS][] configuration.  Clone to `/etc/nixos` and symlink the host-specific
directory to `/etc/nixos/host`.

Home Manager
============

Symlink home.nix:
```
mkdir -p ~/.config/nixpkgs
ln -s /etc/nixos/common/home.nix ~/.config/nixpkgs
```

Add channel and update:
```
nix-channel --add https://github.com/rycee/home-manager/archive/release-20.03.tar.gz home-manager
nix-channel --update
```

Install Home Manager and activate configuration:
```
nix-shell '<home-manager>' -A install
home-manager switch
```

[NixOS]: https://nixos.org
