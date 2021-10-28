_: prev:
with prev; {

  gimpPlugins = gimpPlugins // { bimp = callPackage ./bimp.nix { }; };
}
