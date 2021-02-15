final: prev: {

  amdvlk = prev.callPackage ./amdvlk { };

  _mesa = with prev; callPackage ./mesa {
    llvmPackages = llvmPackages_latest;
    inherit (darwin.apple_sdk.frameworks) OpenGL;
    inherit (darwin.apple_sdk.libs) Xplugin;
  };

}
