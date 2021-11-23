{ flakes, userData, ... }: {

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
    '';

    binaryCaches = [ "https://nix-community.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    sshServe = {
      enable = true;
      keys = userData.authorizedSshKeysRoot;
    };

    registry = __mapAttrs (id: flake: {
      from = {
        type = "indirect";
        inherit id;
      };
      inherit flake;
    }) flakes;
  };
}
