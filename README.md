nixconfig
========

My [NixOS][] configuration.  Clone to `/etc/nixos` and symlink the host-specific
directory to `/etc/nixos/host`.

Add channels and update by running: 
```
sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
sudo nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
```
For getting a specific revision from GitHub: 
`https://github.com/nixos/nixpkgs-channels/archive/<revision>.tar.gz`.

Install Home Manager by running: 
`nix-shell '<home-manager>' -A install`.

[NixOS]: https://nixos.org
