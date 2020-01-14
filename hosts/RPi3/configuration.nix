{ config, lib, pkgs, ... }:

{
  boot.loader.raspberryPi = {
    version = 3;
    enable = true;
    uboot.enable = true;
  };
}
