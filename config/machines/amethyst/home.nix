{ nixosConfig, ... }: {

  # Enable VA-API hardware decoder in mpv.
  programs.mpv.config.hwdec = "vaapi";

  # Apply X touchpad config to Plasma Wayland.
  programs.kde.settings = with nixosConfig.services.xserver.libinput.touchpad; {

    kcminputrc.Libinput."1739"."52560"."SYNA328B:00 06CB:CD50 Touchpad" = {
      DisableWhileTyping = disableWhileTyping;
      NaturalScroll = naturalScrolling;
      TapToClick = tapping;
    };
  };
}
