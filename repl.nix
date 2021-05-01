let
  self = __getFlake "self";
  lib = self.inputs.nixpkgs.lib;
  lib' = lib // import ./lib { inherit lib; };
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
in {
  lib = lib';
  inherit (nixosConfig._module.args) pkgs-master pkgs-unstable;
} // nixosConfig // self.inputs // self
