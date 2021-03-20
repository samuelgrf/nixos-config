_: prev:
with prev; {

  mpv = mpv.override { scripts = [ (callPackage ./playlistmanager.nix { }) ]; };

}
