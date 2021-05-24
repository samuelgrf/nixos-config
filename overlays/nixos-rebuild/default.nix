_: prev:
with prev; {

  nixos-rebuild = nixos-rebuild.overrideAttrs (_: {
    src = fetchurl {
      url =
        "https://raw.githubusercontent.com/samuelgrf/nixpkgs/63a96861b018ad682d4c85745ec7c006d8572f18/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh";
      hash = "sha256-nHK1sDQ17Viljb/4OEMhp8lcElg8tGb4OGfO935jRGs=";
    };
  });

}
