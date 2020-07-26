{ config, ... }:

{
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.03";

  # Automatically optimize the Nix store.
  nix.autoOptimiseStore = true;

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users.samuel = {
    description = "Samuel Gräfenstein";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}