let
  self = __getFlake "self";
  pkgs = self.inputs.nixpkgs.legacyPackages.x86_64-linux;
  lib = self.inputs.nixpkgs.lib;
  lib' = lib // import ./lib { inherit lib pkgs; };
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
in {
  lib = lib';
  inherit (nixosConfig._module.args) binPaths flakes pkgs-master pkgs-unstable;
} // nixosConfig // self.inputs // self
