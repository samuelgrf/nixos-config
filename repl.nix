let
  self = __getFlake "self";
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
  inherit (self) lib lib';

in nixosConfig // self.inputs // self // {
  lib = lib // lib';
  inherit (nixosConfig._module.args) binPaths flakes pkgs-master pkgs-unstable;
}
