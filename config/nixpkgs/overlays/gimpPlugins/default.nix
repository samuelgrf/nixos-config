_final: prev:
with prev; {

  gimpPlugins = gimpPlugins // { bimp = callPackage ./bimp.nix { }; };
}
