{ flakes }:

_: prev:
with prev; {

  mesaUnstable =
    callPackage "${flakes.nixpkgs-unstable}/pkgs/development/libraries/mesa" {
      llvmPackages = llvmPackages_latest;
      inherit (darwin.apple_sdk.frameworks) OpenGL;
      inherit (darwin.apple_sdk.libs) Xplugin;
    };

}
