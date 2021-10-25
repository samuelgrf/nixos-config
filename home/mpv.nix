{
  # Configure mpv.
  programs.mpv = {
    enable = true;
    config = {
      player-operation-mode = "pseudo-gui"; # Always start in GUI mode.
      keep-open = true; # Keep mpv open after playback is finished.
      ytdl-format = # Prefer VP9 and Opus codecs for youtube-dl streams.
        "(bestvideo[vcodec=vp9]/bestvideo)+(bestaudio[acodec=opus]/bestaudio)/best";
    };
  };
}
