{ pkgs-unstable }:

let
  "gimpPlugins.bimp" = importOverlay ./gimpPlugins/bimp.nix;
  "linuxKernel.kernels.linux_zen__config" = importOverlay ./linux_zen/config.nix;
  "linuxKernel.kernels.linux_zen__source" = importOverlay ./linux_zen/source.nix;
  linuxLTOPackages = importOverlay ./linuxLTOPackages;
  nix-index-database = importOverlay ./nix-index-database;
  pdfsizeopt = importOverlay ./pdfsizeopt;
  ungoogled-chromium = importOverlay ./ungoogled-chromium;
  youtube-dl = importOverlayFn ./youtube-dl { inherit pkgs-unstable; };
  importOverlay = f: final: prev: import f final prev;
  importOverlayFn = f: fnArgs: final: prev: import f fnArgs final prev;
in {
  inherit

    "gimpPlugins.bimp" # Init

    "linuxKernel.kernels.linux_zen__config" # Customize kernel configuration.
    "linuxKernel.kernels.linux_zen__source" # Ensure ZFS compatibility.

    # Thanks a lot to @lovesegfault for his work on this!
    # Based on: https://github.com/lovesegfault/nix-config/blob/7ddb02fa8c52b2422c4b74e385ab511a71a6f5e6/nix/overlays/linux-lto.nix
    linuxLTOPackages # Build LinuxPackages* with LLVM and LTO.

    nix-index-database # Init

    pdfsizeopt # Init

    ungoogled-chromium # Add command line arguments.

    youtube-dl; # Replace with yt-dlp.

}
