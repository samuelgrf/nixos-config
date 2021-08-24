{

  # Steam Remote Play
  networking.firewall = {
    allowedTCPPorts = [ 27036 ];
    allowedUDPPortRanges = [{
      from = 27031;
      to = 27036;
    }];
  };

}
