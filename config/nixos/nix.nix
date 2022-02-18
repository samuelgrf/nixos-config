{ flakes, pkgs, userData, ... }: {

  nix = {
    package = pkgs.nix_2_4;

    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = /etc/nix/registry.json
      builders-use-substitutes = true
    '';

    binaryCaches = [ "https://nix-community.cachix.org" ];
    trustedBinaryCaches =
      [ "ssh-ng://amethyst" "ssh://amethyst" "ssh-ng://beryl" "ssh://beryl" ];

    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "amethyst:QyDJyzh9W0VNiYmi5k+jKnlsAzf5zyM79lDfFb6xKPc="
      "beryl:F86Ng/AlmQvOroSienBev7tuhTvHGyDDac/OwIKt85k="
    ];

    sshServe = {
      enable = true;
      keys = userData.authorizedSshKeysRoot;
    };

    registry = __mapAttrs (id: flake: {
      inherit flake;
      from = {
        inherit id;
        type = "indirect";
      };
    }) flakes;
  };
}
