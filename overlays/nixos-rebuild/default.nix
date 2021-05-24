_: prev:
with prev; {

  nixos-rebuild = nixos-rebuild.overrideAttrs (_: {
    src = fetchurl {
      url =
        "https://raw.githubusercontent.com/samuelgrf/nixpkgs/4d60a32db03215ef2f986f1f29f0fe0b9ba40032/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh";
      hash = "sha256-VKWVKo2D4j0HdMmq4y3TPLSCOGAfcFtZqALt6dXEp9I=";
    };
  });

}
