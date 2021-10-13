# TODO Get from prev on NixOS 21.11.
{ pkgs-unstable }:

_: _:
with pkgs-unstable; {

  youtube-dl = yt-dlp.override { withAlias = true; };

}
