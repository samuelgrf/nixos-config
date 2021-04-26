let
  self = (builtins.getFlake flake:self);
  flakes = self.inputs;
  host = with builtins; head (match "([a-zA-Z0-9]+)\n" (readFile "/etc/hostname"));
  nixosConfig = self.nixosConfigurations.${host};
  system = nixosConfig.pkgs.system;
in {
  lib = (flakes.nixpkgs).lib;
  pkgs-master = (flakes.nixpkgs-master).legacyPackages.${system};
  pkgs-unstable = (flakes.nixpkgs-unstable).legacyPackages.${system};
}
// flakes
// nixosConfig
// self
