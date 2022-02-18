{ mpvScripts, yt-dlp, ... }: {

  # Configure mpv.
  programs.mpv = {
    enable = true;
    config = {

      # Always start in GUI mode.
      player-operation-mode = "pseudo-gui";

      # Keep mpv open after playback is finished.
      keep-open = true;

      # Prefer VP9 and Opus codecs for youtube-dl streams.
      ytdl-format =
        "(bestvideo[vcodec=vp9]/bestvideo)+(bestaudio[acodec=opus]/bestaudio)/best";

      # Parse streams with yt-dlp instead of youtube-dl.
      script-opts = "ytdl_hook-ytdl_path=${yt-dlp.exe}";
    };

    scripts = with mpvScripts; [ mpris sponsorblock youtube-quality ];
  };
}
