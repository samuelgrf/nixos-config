{ config, ... }:

{
  # Disable GUI password prompt when using ssh
  programs.ssh.askPassword = "";
}
