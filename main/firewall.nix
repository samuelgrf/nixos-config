{ lib, ... }: {

  networking.firewall = lib.mkMerge [

    # Minecraft server
    {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    }

    # Steam Remote Play
    {
      allowedTCPPorts = [ 27036 ];
      allowedUDPPortRanges = [{
        from = 27031;
        to = 27036;
      }];
    }
  ];

}
