let
  self = __getFlake "self";
  lib = self.inputs.nixpkgs.lib;
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
in {
  inherit (nixosConfig._module.args) lib pkgs-master pkgs-unstable;
}
// nixosConfig
// self.inputs
// self
