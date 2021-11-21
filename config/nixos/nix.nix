{ flakes, userData, ... }: {

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
    '';

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
