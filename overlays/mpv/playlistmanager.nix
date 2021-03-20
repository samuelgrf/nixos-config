{ fetchFromGitHub, lib, mpv-unwrapped, stdenv }:

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.playlistmanager ]; }`
stdenv.mkDerivation rec {
  pname = "mpv-playlistmanager";
  version = "unstable-2021-03-09";

  src = fetchFromGitHub {
    owner = "jonniek";
    repo = pname;
    rev = "c15a0334cf6d4581882fa31ddb1e6e7f2d937a3e";
    hash = "sha256-uxcvgcSGS61UU8MmuD6qMRqpIa53iasH/vkg1xY7MVc=";
  };

  dontBuild = true;

  installPhase = ''
    install -D playlistmanager.lua $out/share/mpv/scripts/playlistmanager.lua
  '';

  passthru.scriptName = "playlistmanager.lua";

  meta = with lib; {
    description = "mpv script for creating and managing playlists";
    inherit (src.meta) homepage;
    license = licenses.unlicense;
    inherit (mpv-unwrapped.meta) platforms;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
