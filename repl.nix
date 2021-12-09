let
  self = __getFlake (toString ./.);
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};
  inherit (self) lib;

in self // self.inputs // nixosConfig // {
  inherit (nixosConfig._module.args)
    binPaths homeConfig flakes pkgs-master pkgs-unstable system;
}
