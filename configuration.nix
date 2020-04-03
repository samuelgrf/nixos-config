{
  imports = [
    ./common.nix
    ./host/configuration.nix
    ./host/hardware.nix
    ./modules/g810-led.nix
    ./modules/qemu-user.nix
  ];
}
