_: prev:
with prev; {

  # TODO Remove if statement on NixOS 21.11.
  youtube-dl =
    if pkgs ? yt-dlp then yt-dlp.override { withAlias = true; } else youtube-dl;

}
