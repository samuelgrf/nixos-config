{ config, ... }:

{
  # Enable VA-API hardware decoder in mpv.
  programs.mpv.enable = true;
  programs.mpv.config.hwdec = "vaapi";
}
