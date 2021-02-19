{ ... }:

{
  # Set mpv configuration.
  programs.mpv = {
    enable = true;
    config.keep-open = true; # Keep mpv open after playback is finished.
    config.ytdl-format = # Prefer VP9 and Opus codecs for youtube-dl streams.
      "(bestvideo[vcodec=vp9]/bestvideo)+(bestaudio[acodec=opus]/bestaudio)/best";
  };
}
