{ config, ... }:

{
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Open ports needed for Steam In-Home Streaming
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];
  networking.firewall.allowedTCPPorts = [ 27036 ];
}
