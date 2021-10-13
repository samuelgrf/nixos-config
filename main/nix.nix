{ config, flakes, nixUnstable, ... }: {

  nix = {
    package = nixUnstable;

    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
    '';

    registry = __mapAttrs (id: flake: {
      from = {
        type = "indirect";
        inherit id;
      };
      inherit flake;
    }) flakes;

    sshServe = {
      enable = true;
      keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };

}
