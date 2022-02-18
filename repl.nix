let
  inherit (self) lib;
  self = __getFlake (toString ./.);
  host = lib.removeSuffix "\n" (__readFile "/etc/hostname");
  nixosConfig = self.nixosConfigurations.${host};

in self // self.inputs // nixosConfig // {
  inherit (nixosConfig._module.args)
    homeConfig flakes pkgs-emacs pkgs-master pkgs-unstable system;
}
