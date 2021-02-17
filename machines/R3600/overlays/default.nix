{ unstable }: final: prev: {

  amdvlk = prev.callPackage "${unstable}/pkgs/development/libraries/amdvlk" { };

  _mesa = with prev; callPackage "${unstable}/pkgs/development/libraries/mesa" {
    llvmPackages = llvmPackages_latest;
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

}
