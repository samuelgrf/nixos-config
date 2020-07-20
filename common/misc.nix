{ config, ... }:

{
  # Disable GUI password prompt when using SSH.
  programs.ssh.askPassword = "";
}
