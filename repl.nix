let
  self = __getFlake (toString ./.);
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
  inherit (self) lib;

in nixosConfig // self.inputs // self // {
  inherit (nixosConfig._module.args)
    binPaths flakes pkgs-master pkgs-unstable system;
}
